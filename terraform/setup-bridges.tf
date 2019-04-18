data "template_file" "setup-bridges-control" {
  template = "${file("${path.module}/setup-bridges.tpl")}"
  count    = "${var.control_count}"

  vars {
    # hard coded for a single control node right now
    MGMT_IP     = "${cidrhost(packet_ip_attachment.control0_mgmt_block.cidr_notation,1)}"
    MGMT_SUBNET = "${packet_ip_attachment.control0_mgmt_block.cidr_notation}"
    VXLAN_IP     = "${cidrhost(packet_ip_attachment.control0_vxlan_block.cidr_notation,1)}"
    VXLAN_SUBNET = "${packet_ip_attachment.control0_vxlan_block.cidr_notation}"
  }
}

data "template_file" "setup-bridges-compute" {
  template = "${file("${path.module}/setup-bridges.tpl")}"
  count    = "${var.compute_count}"

  vars {
    # hard coded for a single compute node right now
    MGMT_IP     = "${cidrhost(packet_ip_attachment.compute0_mgmt_block.cidr_notation,1)}"
    MGMT_SUBNET = "${packet_ip_attachment.compute0_mgmt_block.cidr_notation}"
    VXLAN_IP     = "${cidrhost(packet_ip_attachment.compute0_vxlan_block.cidr_notation,1)}"
    VXLAN_SUBNET = "${packet_ip_attachment.compute0_vxlan_block.cidr_notation}"
  }
}

resource "null_resource" "setup-bridges-control" {

  depends_on = [
    "packet_device.control",
  ]

  count    = "${var.control_count}"

  triggers {
    template_rendered = "${element(data.template_file.setup-bridges-control.*.rendered,count.index)}"
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
    content     = "${element(data.template_file.setup-bridges-control.*.rendered,count.index)}"
    destination = "setup-bridges.sh"
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
#      "bash setup-bridges.sh > setup-bridges.out",
    ]
  }
}

resource "null_resource" "setup-bridges-compute" {

  depends_on = [
    "packet_device.compute",
  ]

  count    = "${var.compute_count}"

  triggers {
    template_rendered = "${element(data.template_file.setup-bridges-compute.*.rendered,count.index)}"
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
    content     = "${element(data.template_file.setup-bridges-compute.*.rendered,count.index)}"
    destination = "setup-bridges.sh"
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
      "bash setup-bridges.sh > setup-bridges.out",
    ]
  }
}
