# Copyright 2019 JHL Consulting LLC
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

data "template_file" "openstack_user_config" {
  
  template = "${file("${path.module}/openstack_user_config-yml.tpl")}"

  vars {
    cloud_id = "${random_id.cloud.hex}"

    control_public_addrs = "${join(",",packet_device.control.*.access_public_ipv4)}"
    compute_public_addrs = "${join(",",packet_device.compute.*.access_public_ipv4)}"

    # assigned individual IP - Private
    infra0_private_addr    = "${packet_device.control.0.access_private_ipv4}"
    compute0_private_addr  = "${packet_device.compute.0.access_private_ipv4}"

    # assigned individual IP - Public
    infra0_public_addr    = "${packet_device.control.0.access_public_ipv4}"
    compute0_public_addr  = "${packet_device.compute.0.access_public_ipv4}"

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
