data "template_file" "setup-br-mgmt-control" {
  template = "${file("${path.module}/setup-br-mgmt.tpl")}"
  count    = "${var.control_count}"

  vars {
    # no public IPs to add
    add-public-ips-command = ""
    # private subnet assigned to this host
    #add-private-ips-command = "ip addr add ${element(packet_ip_attachment.control_ip_block.*.cidr_notation,count.index) dev br-mgmt}"
    # hard coded for a single control node right now
    # NOTE(curtis): FIXME - need to calculate /27 somehow... 
    add-private-ips-command = "ip addr add ${local.control_0_container_subnet_gw}/27 dev br-mgmt"
  }
}

data "template_file" "setup-br-mgmt-compute" {
  template = "${file("${path.module}/setup-br-mgmt.tpl")}"
  count    = "${var.compute_count}"

  vars {
    # no public IPs to add
    add-public-ips-command = ""
    # private subnet assigned to this host
    #add-private-ips-command = "ip addr add ${element(packet_ip_attachment.compute_ip_block.*.cidr_notation,count.index) dev br-mgmt}"
    # hard coded for a single compute node right now
    # FIXME: This will likely not work as the cidr_notation here uses the network IP, not a usable host IP, eg. minhost
    add-private-ips-command = "ip addr add ${local.compute_0_container_subnet_gw}/27  dev br-mgmt"
  }
}

resource "null_resource" "setup-br-mgmt-control" {

  depends_on = [
    "packet_device.control",
  ]

  count    = "${var.control_count}"

  triggers {
    template_rendered = "${element(data.template_file.setup-br-mgmt-control.*.rendered,count.index)}"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.control.*.access_public_ipv4,count.index)}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    content     = "${element(data.template_file.setup-br-mgmt-control.*.rendered,count.index)}"
    destination = "setup-br-mgmt.sh"
  }

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
      "bash setup-br-mgmt.sh > setup-br-mgmt.out",
    ]
  }
}

resource "null_resource" "setup-br-mgmt-compute" {

  depends_on = [
    "packet_device.compute",
  ]

  count    = "${var.compute_count}"

  triggers {
    template_rendered = "${element(data.template_file.setup-br-mgmt-compute.*.rendered,count.index)}"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.compute.*.access_public_ipv4,count.index)}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    content     = "${element(data.template_file.setup-br-mgmt-compute.*.rendered,count.index)}"
    destination = "setup-br-mgmt.sh"
  }

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
      "bash setup-br-mgmt.sh > setup-br-mgmt.out",
    ]
  }
}
