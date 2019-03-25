data "template_file" "setup-bridges-control" {
  template = "${file("${path.module}/setup-bridges.tpl")}"
  count    = "${var.control_count}"

  vars {
    # no public IPs to add
    add-public-ips-command = ""
    # private subnet assigned to this host
    #add-private-ips-command = "ip addr add ${element(packet_ip_attachment.control_ip_block.*.cidr_notation,count.index) dev br-mgmt}"
    # hard coded for a single control node right now
    add-private-ips-command = "ip addr add $packet_ip_attachment.control_ip_block.0.cidr_notation) dev br-mgmt}"
  }
}

data "template_file" "setup-bridges-compute" {
  template = "${file("${path.module}/setup-bridges.tpl")}"
  count    = "${var.compute_count}"

  vars {
    # no public IPs to add
    add-public-ips-command = ""
    # private subnet assigned to this host
    #add-private-ips-command = "ip addr add ${element(packet_ip_attachment.compute_ip_block.*.cidr_notation,count.index) dev br-mgmt}"
    # hard coded for a single compute node right now
    add-private-ips-command = "ip addr add $packet_ip_attachment.compute_ip_block.0.cidr_notation) dev br-mgmt}"
  }
}

resource "null_resource" "setup-bridges-control" {
  count    = "${var.control_count}"

  triggers {
    template_rendered = "${element(data.template_file.setup-bridges-control.*.rendered,count.index)}"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.control.*.access_public_ipv4,count.index)}"
      private_key = "${file("${var.cloud_ssh_key_path}")}"
    }
    content     = "${element(data.template_file.setup-bridges-control.*.rendered,count.index)}"
    destination = "setup-bridges.sh"
  }
}

resource "null_resource" "setup-bridges-compute" {
  count    = "${var.compute_count}"

  triggers {
    template_rendered = "${element(data.template_file.setup-bridges-compute.*.rendered,count.index)}"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.compute.*.access_public_ipv4,count.index)}"
      private_key = "${file("${var.cloud_ssh_key_path}")}"
    }
    content     = "${element(data.template_file.setup-bridges-compute.*.rendered,count.index)}"
    destination = "setup-bridges.sh"
  }
}

