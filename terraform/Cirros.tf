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
# spin up some Cirros instances on the cloud
#
resource "null_resource" "cirros-instances" {

# right now this just copies over the file - later it'll run it and then it'll need this dependency
#  depends_on = ["null_resource.osa-playbooks"]

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
    source      = "Cirros.sh"
    destination = "Cirros.sh"
  }

  # TODO 
  # find the lxc utility container
  # push file into container
  # run the file
#  provisioner "remote-exec" {
#    inline = [
#       "lxc file push Cirros.sh utility-container-name/"
#       "lxc-attach -n utility-container-name -- bash Cirros.sh"
#    ]
#  }
}
