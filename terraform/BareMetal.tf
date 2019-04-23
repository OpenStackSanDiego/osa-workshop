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


resource "packet_ssh_key" "default" {
  name       = "default"
  public_key = "${tls_private_key.default.public_key_openssh}"
}

resource "packet_device" "compute" {

  depends_on       = ["packet_ssh_key.default"]


  count            = "${var.compute_count}"
  hostname         = "${format("compute%01d", count.index)}"
  operating_system = "${var.operating_system}"
  plan             = "${var.compute_type}"
  tags             = ["openstack-${random_id.cloud.hex}","${var.terraform_username}"]


  connection {
    user        = "root"
    private_key = "${tls_private_key.default.private_key_pem}"
    agent       = false
    timeout     = "30s"
  }
  facilities    = ["${var.packet_facility}"]
  project_id    = "${packet_project.osa.id}"
  billing_cycle = "hourly"

  provisioner "file" {
    source      = "${var.operating_system}-${var.compute_type}.sh"
    destination = "hardware-setup.sh"
  }

  provisioner "file" {
    source      = "${var.operating_system}.sh"
    destination = "os-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -A", 
      "bash hardware-setup.sh > hardware-setup.out",
      "bash os-setup.sh > os-setup.out",
    ]
  }
}

resource "packet_device" "control" {

  depends_on       = ["packet_ssh_key.default"]

  count            = "${var.infra_count}"
  hostname         = "${format("infra%01d", count.index)}"
  operating_system = "${var.operating_system}"
  plan             = "${var.infra_type}"
  tags             = ["openstack-${random_id.cloud.hex}","${var.terraform_username}"]

  connection {
    user        = "root"
    private_key = "${tls_private_key.default.private_key_pem}"
    agent       = false
    timeout     = "30s"
  }
  facilities    = ["${var.packet_facility}"]
  project_id    = "${packet_project.osa.id}"
  billing_cycle = "hourly"

  provisioner "file" {
    source      = "${var.operating_system}-${var.infra_type}.sh"
    destination = "hardware-setup.sh"
  }

  provisioner "file" {
    source      = "${var.operating_system}.sh"
    destination = "os-setup.sh"
  }

  provisioner "file" {
    source      = "deployment_host.sh"
    destination = "deployment_host.sh"
  }

  # private SSH key for OSA to use
  provisioner "file" {
    content    = "${tls_private_key.default.private_key_pem}"
    destination = "osa_rsa.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -A", 
      "bash hardware-setup.sh > hardware-setup.out",
      "bash os-setup.sh > os-setup.out",
      "bash deployment_host.sh > deployment_host.out",
    ]
  }

  provisioner "file" {
    source      = "user_variables.yml"
    destination = "/etc/openstack_deploy/user_variables.yml"
  }
}
