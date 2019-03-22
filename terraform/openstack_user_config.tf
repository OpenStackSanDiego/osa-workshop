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
    infrastructure_hosts = "${join(",", data.template_file.infrastructure_hosts.*.rendered)}"
    compute_hosts        = "${join(",", data.template_file.compute_hosts.*.rendered)}"

    control_hostnames = "${jsonencode(join(",", packet_device.control.*.hostname))}"
    control_public_ips = "${join(",",packet_device.control.*.access_public_ipv4)}"
    compute_public_ips = "${join(",",packet_device.compute.*.access_public_ipv4)}"

    control_private_ip = "${packet_device.control.0.access_private_ipv4}"
    private_cidr = "${lookup(packet_device.control.0.network[2], "cidr")}"
    private_gw   = "${lookup(packet_device.control.0.network[2], "gateway")}"

    # subnet assigned to the controller for containers
    container_nw   = "${packet_ip_attachment.container_ip_block.cidr_notation}"

    all_host_private_ips = "${join(",",packet_device.control.*.access_private_ipv4,
                                       packet_device.compute.*.access_private_ipv4)}"

    all_host_public_ips = "${join(",",packet_device.control.*.access_public_ipv4,
                                      packet_device.compute.*.access_public_ipv4)}"
  }
}

resource "null_resource" "inventory" {
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
      private_key = "${file("${var.cloud_ssh_key_path}")}"
    }
    source      = "${var.openstack_user_config_file}"
    destination = "/etc/openstack_deploy/openstack_user_config.yml"
  }
}
