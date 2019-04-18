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

    infra_hostnames    = "${jsonencode(join(",", packet_device.control.*.hostname))}"
    compute_hostnames  = "${jsonencode(join(",", packet_device.control.*.hostname))}"

    control_public_addrs = "${join(",",packet_device.control.*.access_public_ipv4)}"
    compute_public_addrs = "${join(",",packet_device.compute.*.access_public_ipv4)}"

    # assigned individual IP - Private
    infra0_private_addr    = "${packet_device.control.0.access_private_ipv4}"
    infra0_private_cidr    = "${lookup(packet_device.control.0.network[2], "cidr")}"
    infra0_private_gw      = "${lookup(packet_device.control.0.network[2], "gateway")}"

    compute0_private_addr  = "${packet_device.compute.0.access_private_ipv4}"
    compute0_private_cidr  = "${lookup(packet_device.compute.0.network[2], "cidr")}"
    compute0_private_gw    = "${lookup(packet_device.compute.0.network[2], "gateway")}"

    # assigned individual IP - Public
    infra0_public_addr    = "${packet_device.control.0.access_public_ipv4}"
    infra0_public_cidr    = "${lookup(packet_device.control.0.network[3], "cidr")}"
    infra0_public_gw      = "${lookup(packet_device.control.0.network[3], "gateway")}"

    compute0_public_addr  = "${packet_device.compute.0.access_public_ipv4}"
    compute0_public_cidr  = "${lookup(packet_device.compute.0.network[3], "cidr")}"
    compute0_public_gw    = "${lookup(packet_device.compute.0.network[3], "gateway")}"

    # subnet for containers
    # gateway is the first IP in the subnet
    infra0_container_subnet      = "${packet_ip_attachment.control0_mgmt_block.cidr_notation}"
    infra0_container_gw          = "${cidrhost(packet_ip_attachment.control0_mgmt_block.cidr_notation,1)}"

    compute0_container_subnet    = "${packet_ip_attachment.compute0_mgmt_block.cidr_notation}"
    compute0_container_gw        = "${cidrhost(packet_ip_attachment.compute0_mgmt_block.cidr_notation,1)}"

    # subnet for vxlan tunnel tenant network
    infra0_tunnel_subnet         = "${packet_ip_attachment.control0_vxlan_block.cidr_notation}"
    infra0_tunnel_gw             = "${cidrhost(packet_ip_attachment.control0_vxlan_block.cidr_notation,1)}"

    compute0_tunnel_subnet       = "${packet_ip_attachment.compute0_vxlan_block.cidr_notation}"
    compute0_tunnel_gw           = "${cidrhost(packet_ip_attachment.compute0_vxlan_block.cidr_notation,1)}"

    # private subnet assigned to the project (full block which is then split across hosts)
#    project_private_subnet = "${data.packet_precreated_ip_block.private_block.cidr_notation}"
#
#    all_host_private_ips = "${join(",",packet_device.control.*.access_private_ipv4,
#                                       packet_device.compute.*.access_private_ipv4)}"
#
#    all_host_public_ips = "${join(",",packet_device.control.*.access_public_ipv4,
#                                      packet_device.compute.*.access_public_ipv4)}"
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
