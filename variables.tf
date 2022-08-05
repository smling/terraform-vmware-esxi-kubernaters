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