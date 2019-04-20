variable "project_name" {
  description = "Project Name"
  default = "OSA Project"
}

resource "packet_project" "osa" {
  name       = "${var.project_name}"
}
