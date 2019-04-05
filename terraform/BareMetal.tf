
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
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""
  facilities    = ["${var.packet_facility}"]
  project_id    = "${var.packet_project_id}"
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
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""
  facilities    = ["${var.packet_facility}"]
  project_id    = "${var.packet_project_id}"
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

# NOTE(curtis): This file is copied into place by deployment_host.sh
  provisioner "file" {
    source      = "user_variables.yml"
    destination = "user_variables.yml"
  }

  # private SSH key for OSA to use
  provisioner "file" {
    source      = "${var.cloud_ssh_key_path}"
    destination = "osa_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -A", 
      "bash hardware-setup.sh > hardware-setup.out",
      "bash os-setup.sh > os-setup.out",
      "bash deployment_host.sh > deployment_host.out",
    ]
  }
}
