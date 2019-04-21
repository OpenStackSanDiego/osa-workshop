output "Cloud ID Tag" {
  value = "${random_id.cloud.hex}"
}

output "Compute public IPs" {
  value = "${packet_device.compute.*.access_public_ipv4}"
}

output "Infra/Control public IPs" {
  value = "${packet_device.control.*.access_public_ipv4}"
}

output "SSH Access to run OpenStack-Ansible Playbooks"  {
  value = "ssh root@${packet_device.control.0.access_public_ipv4} -i default.pem"
}
