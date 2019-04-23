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
  depends_on = ["tls_private_key.default"]
  name       = "default"
  public_key = "${tls_private_key.default.public_key_openssh}"
}

resource "packet_device" "lab-master" {

  depends_on       = ["packet_ssh_key.default"]

  hostname         = "${var.hostname}"
  operating_system = "${var.operating_system}"
  plan             = "${var.instance_type}"

  connection {
    user        = "root"
    private_key = "${tls_private_key.default.private_key_pem}"
    agent       = false
    timeout     = "30s"
  }
  facilities    = ["${var.packet_facility}"]
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"

  provisioner "file" {
    source      = "${var.operating_system}.sh"
    destination = "os-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -A", 
      "bash os-setup.sh > os-setup.out",
    ]
  }
}
