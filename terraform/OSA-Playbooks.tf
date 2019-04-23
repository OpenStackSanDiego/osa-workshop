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

#
# run the OSA playbooks to setup the hosts, infrastructure, and OpenStack
#
resource "null_resource" "osa-playbooks" {

  depends_on = ["packet_device.control",
                "packet_device.compute",
                "null_resource.distribute-key-control",
                "null_resource.ssh-agent-setup-control",
                "null_resource.setup-bridges-control",
                "null_resource.setup-bridges-compute"]

  # count of zero will prevent this from running
  count         = "1"

  connection {
    type        = "ssh"
    user        = "root"
    host        = "${packet_device.control.0.access_public_ipv4}"
    private_key = "${tls_private_key.default.private_key_pem}"
    agent       = false
    timeout     = "30s"
  }

  provisioner "file" {
    source      = "osa-playbooks.sh"
    destination = "osa-playbooks.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash osa-playbooks.sh > osa-playbooks.out",
    ]
  }
}
