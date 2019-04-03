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


locals {
    # NOTE(curtis): Use the first IP in the range as the gateway, put this on br-mgmt
    control_0_container_subnet_gw = "${cidrhost(packet_ip_attachment.control_ip_block_0.cidr_notation,1)}"
    compute_0_container_subnet_gw = "${cidrhost(packet_ip_attachment.compute_ip_block_0.cidr_notation,1)}"
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
