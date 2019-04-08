
# the master private IPv4 address space assigned by Packet
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

# block above is split out across the different uses
# assigned a /25 by default so we subnet out to multiple /28

resource "packet_ip_attachment" "control0_mgmt_block" {
    device_id     = "${packet_device.control.0.id}"
    cidr_notation = "${cidrsubnet(data.packet_precreated_ip_block.private_block.cidr_notation,3,1)}"
}

resource "packet_ip_attachment" "compute0_mgmt_block" {
    device_id     = "${packet_device.compute.0.id}"
    cidr_notation = "${cidrsubnet(data.packet_precreated_ip_block.private_block.cidr_notation,3,2)}"
}

resource "packet_ip_attachment" "control0_vxlan_block" {
    device_id     = "${packet_device.control.0.id}"
    cidr_notation = "${cidrsubnet(data.packet_precreated_ip_block.private_block.cidr_notation,3,3)}"
}

resource "packet_ip_attachment" "compute0_vxlan_block" {
    device_id     = "${packet_device.compute.0.id}"
    cidr_notation = "${cidrsubnet(data.packet_precreated_ip_block.private_block.cidr_notation,3,4)}"
}
