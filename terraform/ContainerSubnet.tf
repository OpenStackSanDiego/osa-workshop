data "packet_precreated_ip_block" "private_block" {
    depends_on = [
      "packet_device.control",
      "packet_device.compute",
    ]

    facility         = "${var.packet_facility}"
    project_id       = "${var.packet_project_id}"
    address_family   = 4
    public           = false
}

# assigned a /25 by default so we'll add one bit and get a /26
resource "packet_ip_attachment" "control_ip_block_0" {
    device_id     = "${packet_device.control.0.id}"
    cidr_notation = "${cidrsubnet(data.packet_precreated_ip_block.private_block.cidr_notation,2,1)}"
}

resource "packet_ip_attachment" "compute_ip_block_0" {
    device_id     = "${packet_device.compute.0.id}"
    cidr_notation = "${cidrsubnet(data.packet_precreated_ip_block.private_block.cidr_notation,2,2)}"
}
