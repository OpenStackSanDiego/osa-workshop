
# set via environment variable TF_VAR_packet_project_id
variable "packet_project_id" {
  description = "Packet Project ID"
}

# set via environment variable TF_VAR_packet_auth_token
variable "packet_auth_token" {
  description = "Packet API Token"
}

variable "packet_facility" {
  description = "Packet facility. Default: dfw2"
  default = "dfw2"
}

variable "compute_type" {
  description = "Instance type of OpenStack compute nodes"
  default = "c2.medium.x86"
}

variable "compute_count" {
  description = "Number of OpenStack compute nodes to deploy"
  default = "1"
}

variable "control_type" {
  description = "Instance type of OpenStack control nodes"
  default = "c2.medium.x86"
}

variable "control_count" {
  description = "Number of OpenStack control nodes to deploy"
  default = "1"
}

variable "operating_system" {
  description = "Operating System to install across nodes"
  default = "ubuntu_18_04"
}

variable "cloud_ssh_public_key_path" {
  description = "Path to your authorized keys to put on hosts"
  default = "./authorized_keys"
}

variable "cloud_ssh_key_path" {
  description = "Path to your private SSH key for the project"
  default = "~/.ssh/id_rsa"
}
variable "openstack_user_config_file" {
  description = "output OSA configuration file"
  default = "openstack_user_config.yml"
}

variable "terraform_username" {
  description = "username running Terraform to set in host tags to help identify resource owners"
}
