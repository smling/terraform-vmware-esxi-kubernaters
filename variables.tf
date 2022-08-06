#
# Reference: https://www.terraform.io/language/values/variables
#
variable "default_password" {
  type = string
  sensitive = true
}

variable "master_nodes" {
  type    = list(string)
  default = ["vm-k8s-sr01"]
}

variable "worker_nodes" {
  type    = list(string)
  default = ["vm-k8s-sr02", "vm-k8s-sr03"]
}
variable "ssh_public_key_path" {
  type = string
  default = "C:\\Users\\chunho.ling/.ssh/id_rsa.pub"
}
variable "ssh_private_key_path" {
  type = string
  default = "C:\\Users\\chunho.ling/.ssh/id_rsa"
  sensitive = true
}