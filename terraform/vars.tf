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


# set via environment variable TF_VAR_packet_auth_token
variable "packet_auth_token" {
  description = "Packet API Token"
}

variable "packet_facility" {
  description = "Packet facility. Default: ewr1"
  default = "ewr1"
}

variable "compute_type" {
  description = "Instance type of OpenStack compute nodes"
  default = "c1.small.x86"
}

variable "compute_count" {
  description = "Number of OpenStack compute nodes to deploy"
  default = "1"
}

variable "operating_system" {
  description = "Operating System to install across nodes"
  default = "ubuntu_18_04"
}

variable "openstack_user_config_file" {
  description = "output OSA configuration file"
  default = "openstack_user_config.yml"
}

variable "terraform_username" {
  description = "username running Terraform to set in host tags to help identify resource owners"
}

variable "infra_type" {
  description = "Instance type of OpenStack infra nodes"
  default = "c1.small.x86"
}

variable "infra_count" {
  description = "number of compute instances"
  default = "1"
}
