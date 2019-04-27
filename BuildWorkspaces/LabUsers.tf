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


resource "null_resource" "lab-users" {

  depends_on    = ["null_resource.lab-software"]

  connection {
    user        = "root"
    private_key = "${tls_private_key.default.private_key_pem}"
    host        = "${packet_device.lab-master.access_public_ipv4}"
    agent       = false
    timeout     = "30s"
  }

  provisioner "file" {
    source      = "create-workspaces.sh"
    destination = "create-workspaces.sh"
  }

  provisioner "file" {
    source      = "delete-workspaces.sh"
    destination = "delete-workspaces.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash create-workspaces.sh ${var.packet_auth_token} ${var.number_labs} ${var.packet_facility} > create-workspaces.out",
    ]
  }

}
