data "template_file" "network-interfaces-control" {
  template = "${file("${path.module}/network-interfaces.tpl")}"
  count    = "${var.control_count}"

  vars {
    br-mgmt-ip = "${cidrhost(element(packet_reserved_ip_block.br-mgmt-control.*.cidr_notation,count.index),0)}"
  }
}

data "template_file" "network-interfaces-compute" {
  template = "${file("${path.module}/network-interfaces.tpl")}"
  count    = "${var.compute_count}"

  vars {
    br-mgmt-ip = "${cidrhost(element(packet_reserved_ip_block.br-mgmt-compute.*.cidr_notation,count.index),0)}"
  }
}

resource "null_resource" "network-interfaces-control" {
  count    = "${var.control_count}"

  triggers {
    template_rendered = "${element(data.template_file.network-interfaces-control.*.rendered,count.index)}"
  }

#  provisioner "local-exec" {
#    command = "echo '${data.template_file.network-interfaces.rendered}' > network-interfaces-control-count.index.txt"
#  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.control.*.access_public_ipv4,count.index)}"
      private_key = "${file("${var.cloud_ssh_key_path}")}"
    }
    content     = "${element(data.template_file.network-interfaces-control.*.rendered,count.index)}"
    destination = "network-interfaces.txt"
  }
}
