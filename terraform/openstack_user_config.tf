data "template_file" "infrastructure_hosts" {
  depends_on = [
    "packet_device.control",
  ]

  count = "${var.control_count}"

  template = <<JSON
$${hostname}:
    ip: $${public_ip}
JSON

 vars {
    public_ip = "${element(packet_device.control.*.access_public_ipv4, count.index)}"
    hostname  = "${element(packet_device.control.*.hostname, count.index)}"
  }
}

data "template_file" "compute_hosts" {
  depends_on = [
    "packet_device.compute",
  ]

  count = "${var.compute_count}"

  template = <<JSON
$${hostname}:
    ip: $${public_ip}
JSON

  vars {
    public_ip = "${element(packet_device.compute.*.access_public_ipv4, count.index)}"
    hostname  = "${element(packet_device.compute.*.hostname, count.index)}"
  }
}
data "template_file" "openstack_user_config" {
  template = "${file("${path.module}/openstack_user_config-yml.tpl")}"

  vars {
    cloud_id = "${random_id.cloud.hex}"

    infrastructure_hosts = "${join(",", data.template_file.infrastructure_hosts.*.rendered)}"
    compute_hosts        = "${join(",", data.template_file.compute_hosts.*.rendered)}"

    control_hostnames = "${jsonencode(join(",", packet_device.control.*.hostname))}"
    control_public_ips = "${join(",",packet_device.control.*.access_public_ipv4)}"
    compute_public_ips = "${join(",",packet_device.compute.*.access_public_ipv4)}"

    # NOTE(curtis): This is for setting internal and external lb in OSA user config
    # FIXME: should follow naming standard. Also, how would this work with multiple controllers?
    first_control_public_ip = "${element(packet_device.control.*.access_public_ipv4, 0)}"
    first_control_private_ip = "${element(packet_device.control.*.access_private_ipv4, 0)}"

    # assigned individual IP
    control_0_private_ip     = "${packet_device.control.0.access_private_ipv4}"
    compute_0_private_cidr   = "${lookup(packet_device.control.0.network[2], "cidr")}"
    control_0_private_gw     = "${lookup(packet_device.control.0.network[2], "gateway")}"

    compute_0_private_ip     = "${packet_device.compute.0.access_private_ipv4}"
    compute_0_private_cidr = "${lookup(packet_device.compute.0.network[2], "cidr")}"
    compute_0_private_gw     = "${lookup(packet_device.compute.0.network[2], "gateway")}"

    # extra block of private IPs assigned to hosts
    control_0_container_subnet_gw = "${local.control_0_container_subnet_gw}"
    control_0_container_subnet = "${packet_ip_attachment.control_ip_block_0.cidr_notation}"
    compute_0_container_subnet = "${packet_ip_attachment.compute_ip_block_0.cidr_notation}"

    # private subnet assigned to the project (full block which is then split across hosts)
    project_private_subnet = "${data.packet_precreated_ip_block.private_block.cidr_notation}"

    all_host_private_ips = "${join(",",packet_device.control.*.access_private_ipv4,
                                       packet_device.compute.*.access_private_ipv4)}"

    all_host_public_ips = "${join(",",packet_device.control.*.access_public_ipv4,
                                      packet_device.compute.*.access_public_ipv4)}"
  }
}

resource "null_resource" "copy-openstack_user_config_yml" {
  triggers {
    template_rendered = "${data.template_file.openstack_user_config.rendered}"
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.openstack_user_config.rendered}' > ${var.openstack_user_config_file}"
  }
  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${packet_device.control.*.access_public_ipv4}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    source      = "${var.openstack_user_config_file}"
    destination = "/etc/openstack_deploy/openstack_user_config.yml"
  }
}
