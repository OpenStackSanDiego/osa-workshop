#
# install Ansible Deployment components on first control host
#

resource "null_resource" "deployment-host" {

  depends_on = ["packet_device.control"]

  connection {
    type        = "ssh"
    user        = "root"
    host        = "${packet_device.control.0.access_public_ipv4}"
    private_key = "${tls_private_key.default.private_key_pem}"
    agent       = false
    timeout     = "30s"
  }

  provisioner "file" {
    source      = "deployment_host.sh"
    destination = "deployment_host.sh"
  }

  # private SSH key for OSA to use
  provisioner "file" {
    source      = "${var.cloud_ssh_key_path}"
    destination = "osa_rsa"
  }

  # private SSH key for OSA to use
  provisioner "file" {
    source      = "${var.cloud_ssh_key_path}"
    destination = "osa_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "bash deployment_host.sh > deployment_host.out",
    ]
  }

  # run this after deployment_host.sh so that /etc/openstack_deploy is present
  provisioner "file" {
    source      = "user_variables.yml"
    destination = "/etc/openstack_deploy/user_variables.yml"
  }
}
