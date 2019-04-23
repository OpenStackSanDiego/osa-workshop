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

resource "tls_private_key" "default" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "local_file" "private_key_pem" {

  depends_on = ["tls_private_key.default"]

  content    = "${tls_private_key.default.private_key_pem}"
  filename   = "default.pem"
}

resource "local_file" "public_key_pem" {

  depends_on = ["tls_private_key.default"]

  content    = "${tls_private_key.default.public_key_pem}"
  filename   = "default-pub.pem"
}

resource "local_file" "public_key_openssh" {

  depends_on = ["tls_private_key.default"]

  content    = "${tls_private_key.default.public_key_openssh}"
  filename   = "default-openssh.pub"
}

resource "null_resource" "chmod" {
  depends_on = ["local_file.private_key_pem"]

  triggers = {
    local_file_private_key_pem = "local_file.private_key_pem"
  }

  provisioner "local-exec" {
    command = "chmod 600 default.pem"
  }
}

