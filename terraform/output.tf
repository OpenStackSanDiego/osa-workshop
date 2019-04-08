output "Cloud ID Tag" {
  value = "${random_id.cloud.hex}"
}

output "Compute private IPs" {
  value = "${packet_device.compute.*.access_private_ipv4}"
}

output "Compute public IPs" {
  value = "${packet_device.compute.*.access_public_ipv4}"
}

output "Infra/Control private IPs" {
  value = "${packet_device.control.*.access_private_ipv4}"
}

output "Infra/Control public IPs" {
  value = "${packet_device.control.*.access_public_ipv4}"
}

#output "OSA Configuration File" {
#  value = "${var.openstack_user_config_file}"
#}
#
output "Private IP Block for Project" {
  value = "${data.packet_precreated_ip_block.private_block.cidr_notation}"
}

output "br-mgmt IP for Control 0" {
  value = "${cidrhost(packet_ip_attachment.control0_mgmt_block.cidr_notation,1)}"
}

output "br-mgmt IP for Compute 0" {
  value = "${cidrhost(packet_ip_attachment.compute0_mgmt_block.cidr_notation,1)}"
}

output "br-mgmt IP Block for Control 0" {
  value = "${packet_ip_attachment.control0_mgmt_block.cidr_notation}"
}

output "br-mgmt IP Block for Compute 0" {
  value = "${packet_ip_attachment.compute0_mgmt_block.cidr_notation}"
}

output "br-vxlan IP Block for Control 0" {
  value = "${packet_ip_attachment.control0_vxlan_block.cidr_notation}"
}

output "br-vxlan IP Block for Compute 0" {
  value = "${packet_ip_attachment.compute0_vxlan_block.cidr_notation}"
}
