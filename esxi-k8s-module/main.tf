resource "random_id" "instance_id" {
  byte_length = 8
}

resource "esxi_guest" "default" {
  count = length(var.node_list)

  guest_name     = var.node_list[count.index]
  numvcpus       = var.esxi_vm_guest_default_settings.numvcpus
  memsize        = var.esxi_vm_guest_default_settings.memsize
  boot_disk_size = var.esxi_vm_guest_default_settings.boot_disk_size
  disk_store     = var.esxi_vm_guest_default_settings.disk_store
  network_interfaces {
    virtual_network = var.esxi_vm_guest_default_settings.virtual_network
  }
  ovf_source = local.default-ovf-source
  ovf_properties {
    key   = "instance-id"
    value = random_id.instance_id.hex
  }
  ovf_properties {
    key   = "hostname"
    value = var.node_list[count.index]
  }
  ovf_properties {
    key   = "password"
    value = var.default_password
  }

   ovf_properties {
    key   = "public-keys"
    value = var.ssh_public_key
  }

  provisioner "file" {
    source      = "./scripts/1.24.3/common.sh"
    destination = "/tmp/common.sh"
    connection {
      type     = "ssh"
      host = self.ip_address
      user     = local.default-ssh-user
      password = var.default_password
      timeout = "15s"
      # private_key = var.ssh_private_key
      agent = false
    }
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host = self.ip_address
      user     = local.default-ssh-user
      password = var.default_password
      timeout = "15s"
      # private_key = var.ssh_private_key
      agent = false
    }

    inline = [
      "echo '${var.default_password}' | sudo -S hostnamectl set-hostname ${var.node_list[count.index]}",
      "echo '${var.default_password}' | sudo -S apt update",
      "echo '${var.default_password}' | sudo -S apt upgrade -y",
      "echo '${var.default_password}' | sudo -S chmod 755 /tmp/common.sh",
      "echo '${var.default_password}' | sudo -S bash /tmp/common.sh",
      "echo '${var.default_password}' | sudo -S apt clean"
    ]
  }
}
