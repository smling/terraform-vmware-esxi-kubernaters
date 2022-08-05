#
# Reference: https://www.terraform.io/language/values/variables
#
variable "default_password" {
  type = string
}

variable "master_nodes" {
  type    = list(string)
  default = ["vm-k8s-sr01"]
}

variable "worker_nodes" {
  type    = list(string)
  default = ["vm-k8s-sr02", "vm-k8s-sr03"]
}

variable "esxi_vm_guest_default_settings" {
  type = object({
    numvcpus        = number
    memsize         = number
    boot_disk_size  = number
    disk_store      = string
    virtual_network = string
  })
  default = {
    numvcpus        = 4
    memsize         = 8192
    boot_disk_size  = 40
    disk_store      = "datastore1"
    virtual_network = "VM Network"
  }
}

variable "node_list" {
    type = list(string)
    default = []
}