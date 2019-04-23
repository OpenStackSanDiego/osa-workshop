# Copyright 2019 JHL Consulting LLC
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


# the master private IPv4 address space assigned by Packet
data "packet_precreated_ip_block" "private_block" {
    depends_on = [
      "packet_device.control",
      "packet_device.compute",
    ]

    facility         = "${var.packet_facility}"
    project_id       = "${packet_project.osa.id}"

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
