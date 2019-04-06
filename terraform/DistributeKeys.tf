
#
# copy the keys from the distribution host (infra01) to all the other hosts
#

resource "null_resource" "distribute-key-control" {

  depends_on = ["packet_ssh_key.default"]

  count = "${var.control_count}"

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.control.*.access_public_ipv4,count.index)}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    content     = "${tls_private_key.default.private_key_pem}"
    destination = ".ssh/default.pem"
  }
}

resource "null_resource" "distribute-key-compute" {

  depends_on = ["packet_ssh_key.default"]

  count = "${var.compute_count}"

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.compute.*.access_public_ipv4,count.index)}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    content     = "${tls_private_key.default.private_key_pem}"
    destination = ".ssh/default.pem"
  }
}


resource "null_resource" "ssh-agent-setup-control" {

  depends_on = ["null_resource.distribute-key-control"]

  count = "${var.control_count}"

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.control.*.access_public_ipv4,count.index)}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    inline = [
      "chmod 600 .ssh/default.pem",
      "echo 'eval `ssh-agent`' >> .bashrc",
      "echo 'ssh-add ~/.ssh/default.pem' >> .bashrc",
    ]
  }
}

resource "null_resource" "ssh-agent-setup-compute" {

  depends_on = ["null_resource.distribute-key-compute"]

  count = "${var.compute_count}"

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.compute.*.access_public_ipv4,count.index)}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    inline = [
      "chmod 600 .ssh/default.pem",
      "echo 'eval `ssh-agent`' >> .bashrc",
      "echo 'ssh-add ~/.ssh/default.pem' >> .bashrc",
    ]
  }
}
