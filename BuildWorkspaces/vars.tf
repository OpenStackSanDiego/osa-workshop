
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
