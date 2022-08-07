#########################################
#  ESXI Guest resource
#########################################
#
#  This Guest VM is "bare-metal".   It will be powered on by default
#  by terraform, but it will not boot to any OS. It will however attempt
#  to network boot.
#
module "esxi-k8s-node" {
  source           = "./esxi-k8s-module"
  default_password = var.default_password
  node_list        = var.nodes
  ssh_public_key = "${file(var.ssh_public_key_path)}"
  ssh_private_key = "${file(var.ssh_private_key_path)}"
}