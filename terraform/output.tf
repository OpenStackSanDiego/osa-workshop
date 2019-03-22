output "Cloud ID Tag" {
  value = "${random_id.cloud.hex}"
}

output "Compute IPs" {
  value = "${packet_device.compute.*.access_public_ipv4}"
}

output "Control IPs" {
  value = "${packet_device.control.*.access_public_ipv4}"
}

output "OSA Configuration File" {
  value = "${var.openstack_user_config_file}"
}

output "Precreated IP Block" {
  value = "${data.packet_precreated_ip_block.private_block.cidr_notation}"
}

output "Private IP Block" {
  value = "${packet_ip_attachment.container_ip_block.cidr_notation}"
}
