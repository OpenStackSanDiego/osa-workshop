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
# copy the keys from the distribution host (infra01) to all the other hosts
#

resource "null_resource" "distribute-key-control" {

  depends_on = ["packet_ssh_key.default"]

  count = "${var.infra_count}"

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.control.*.access_public_ipv4,count.index)}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    content     = "${tls_private_key.default.private_key_pem}"
    destination = ".ssh/default.pem"
  }
}

resource "null_resource" "distribute-key-compute" {

  depends_on = ["packet_ssh_key.default"]

  count = "${var.compute_count}"

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.compute.*.access_public_ipv4,count.index)}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    content     = "${tls_private_key.default.private_key_pem}"
    destination = ".ssh/default.pem"
  }
}


resource "null_resource" "ssh-agent-setup-control" {

  depends_on = ["null_resource.distribute-key-compute",
                "null_resource.distribute-key-control"]

  count = "${var.infra_count}"

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.control.*.access_public_ipv4,count.index)}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    inline = [
      "chmod 600 .ssh/default.pem",
      "echo 'eval `ssh-agent`' >> .bashrc",
      "echo 'ssh-add ~/.ssh/default.pem' >> .bashrc",
    ]
  }
}

resource "null_resource" "ssh-agent-setup-compute" {

  depends_on = ["null_resource.distribute-key-compute",
                "null_resource.distribute-key-control"]

  count = "${var.compute_count}"

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${element(packet_device.compute.*.access_public_ipv4,count.index)}"
      private_key = "${tls_private_key.default.private_key_pem}"
      agent       = false
      timeout     = "30s"
    }
    inline = [
      "chmod 600 .ssh/default.pem",
      "echo 'eval `ssh-agent`' >> .bashrc",
      "echo 'ssh-add ~/.ssh/default.pem' >> .bashrc",
    ]
  }
}
