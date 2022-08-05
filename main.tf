#########################################
#  ESXI Guest resource
#########################################
#
#  This Guest VM is "bare-metal".   It will be powered on by default
#  by terraform, but it will not boot to any OS. It will however attempt
#  to network boot.
#
module "esxi-k8s-master" {
  source           = "./esxi-k8s-module"
  default_password = var.default_password
  node_list        = var.master_nodes
}