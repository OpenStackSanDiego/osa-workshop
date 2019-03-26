resource "packet_device" "compute" {

  count            = "${var.compute_count}"
  hostname         = "${format("compute%01d", count.index)}"
  operating_system = "${var.operating_system}"
  plan             = "${var.compute_type}"
  tags             = ["openstack-${random_id.cloud.hex}","${var.terraform_username}"]


  connection {
    user = "root"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""
  facilities    = ["${var.packet_facility}"]
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"

  # /29 or /28 required for bridge
  # see https://support.packet.com/kb/articles/kvm-qemu-bridging-on-a-bonded-network
  #public_ipv4_subnet_size  = "29"

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

  count            = "${var.control_count}"
  hostname         = "${format("infra%01d", count.index)}"
  operating_system = "${var.operating_system}"
  plan             = "${var.control_type}"
  tags             = ["openstack-${random_id.cloud.hex}","${var.terraform_username}"]

  connection {
    user = "root"
    private_key = "${file("${var.cloud_ssh_key_path}")}"
  }
  user_data     = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.cloud_ssh_public_key_path}")}\""
  facilities    = ["${var.packet_facility}"]
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"

  # /29 or /28 required for bridge
  # see https://support.packet.com/kb/articles/kvm-qemu-bridging-on-a-bonded-network
  #public_ipv4_subnet_size  = "29"

  provisioner "file" {
    source      = "${var.operating_system}-${var.control_type}.sh"
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
