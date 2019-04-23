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

output "Cloud ID Tag" {
  value = "${random_id.cloud.hex}"
}

output "Compute public IPs" {
  value = "${packet_device.compute.*.access_public_ipv4}"
}

output "Infra/Control public IPs" {
  value = "${packet_device.control.*.access_public_ipv4}"
}

output "SSH Access to infra0"  {
  value = "ssh root@${packet_device.control.0.access_public_ipv4} -i default.pem"
}

output "SSH Access to compute0"  {
  value = "ssh root@${packet_device.compute.0.access_public_ipv4} -i default.pem"
}

output "Project ID" {
  value ="${ packet_project.osa.id}"
}
