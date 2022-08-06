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
  # ovf_properties {
  #   key   = "instance-id"
  #   value = random_id.instance_id.hex
  # }
  ovf_properties {
    key   = "hostname"
    value = var.node_list[count.index]
  }
  ovf_properties {
    key   = "password"
    value = var.default_password
  }
  
  provisioner "remote-exec" {

    inline = [
      "sudo apt update",
      "sudo apt upgrade -y"
    ]

    connection {
      type     = "ssh"
      host = "${self.ip_address}"
      user     = "${local.default-ssh-user}"
      password = var.default_password
      timeout = "30s"
    }
  }
}
