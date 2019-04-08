resource "null_resource" "deploymet_host" {

  depends_on       = ["packet_device.control"]

  # install only on the infra0
  connection {
    user        = "root"
    host        = "${packet_device.control.0.access_public_ipv4}"
    private_key = "${tls_private_key.default.private_key_pem}"
    agent       = false
    timeout     = "30s"
  }

  provisioner "remote-exec" {
    inline = [
      "bash deployment_host.sh > deployment_host.out",
    ]
  }
}
