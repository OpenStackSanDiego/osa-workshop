#
# run the OSA playbooks to setup the hosts, infrastructure, and OpenStack
#
resource "null_resource" "osa-playbooks" {

  depends_on = ["null_resource.deployment-host", 
                "packet_device.control",
                "packet_device.compute",
                "null_resource.distribute-key-control",
                "null_resource.ssh-agent-setup-control",
                "null_resource.setup-bridges-control",
                "null_resource.setup-bridges-compute"]

  # count of zero will prevent this from running
  count         = "0"

  connection {
    type        = "ssh"
    user        = "root"
    host        = "${packet_device.control.0.access_public_ipv4}"
    private_key = "${tls_private_key.default.private_key_pem}"
    agent       = false
    timeout     = "30s"
  }

  provisioner "remote-exec" {
    inline = [
      "( cd /opt/openstack-ansible ; ./scripts/pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml)" ,
      "cd /opt/openstack-ansible/playbooks/",
      "openstack-ansible setup-infrastructure.yml --syntax-check",
      "openstack-ansible setup-hosts.yml",
      "openstack-ansible setup-infrastructure.yml",
      "openstack-ansible setup-openstack.yml",
    ]
  }
}
