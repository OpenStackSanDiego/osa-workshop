locals {
    # Use the first IP in the range as the gateway, put this on br-vxlan
    control_0_vxlan_subnet_gw = "${cidrhost(packet_ip_attachment.control_vxlan_block_0.cidr_notation,1)}"
    compute_0_vxlan_subnet_gw = "${cidrhost(packet_ip_attachment.compute_vxlan_block_0.cidr_notation,1)}"
}

resource "packet_ip_attachment" "control_vxlan_block_0" {
    device_id     = "${packet_device.control.0.id}"
    cidr_notation = "${cidrsubnet(data.packet_precreated_ip_block.private_block.cidr_notation,3,3)}"
}

resource "packet_ip_attachment" "compute_vxlan_block_0" {
    device_id     = "${packet_device.compute.0.id}"
    cidr_notation = "${cidrsubnet(data.packet_precreated_ip_block.private_block.cidr_notation,3,4)}"
}
