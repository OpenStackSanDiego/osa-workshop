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


# set via environment variable TF_VAR_packet_project_id
variable "packet_project_id" {
  description = "Packet Project ID"
}

# set via environment variable TF_VAR_packet_auth_token
variable "packet_auth_token" {
  description = "Packet API Token"
}

variable "hostname" {
  description = "Lab hostname"
  default = "osa-lab-master"
}

variable "packet_facility" {
  description = "Packet facility. Default: ewr1"
  default = "ewr1"
}

variable "instance_type" {
  description = "Instance type"
  default = "c1.small.x86"
}

variable "operating_system" {
  description = "Operating System"
  default = "ubuntu_18_04"
}

variable "number_labs" {
  description = "Number of labs to create"
  default = "3"
}
