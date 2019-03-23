# allocate a single private IPv4 for br-mgmt

resource "packet_reserved_ip_block" "br-mgmt-control" {
  project_id = "${var.packet_project_id}"
  facility   = "${var.packet_facility}"
  type       = "public_ipv4"
  quantity   = 1
  count      = "${var.control_count}"
}

resource "packet_reserved_ip_block" "br-mgmt-compute" {
  project_id = "${var.packet_project_id}"
  facility   = "${var.packet_facility}"
  type       = "public_ipv4"
  quantity   = 1
  count      = "${var.compute_count}"
}

resource "packet_ip_attachment" "br-mgmt-compute" {
  device_id     = "${element(packet_device.compute.*.id, count.index)}"
  cidr_notation = "${element(packet_reserved_ip_block.br-mgmt-compute.*.cidr_notation, count.index)}"
  count         = "${var.control_count}"
}

resource "packet_ip_attachment" "br-mgmt-control" {
  device_id     = "${element(packet_device.control.*.id, count.index)}"
  cidr_notation = "${element(packet_reserved_ip_block.br-mgmt-control.*.cidr_notation, count.index)}"
  count         = "${var.control_count}"
}

