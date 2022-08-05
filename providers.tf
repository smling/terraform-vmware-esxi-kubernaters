#########################################
#  ESXI Provider host/login details
#########################################
#
# Reference: https://www.terraform.io/language/values/variables
#
variable "esxi_hostname" {
  description = "ESXI server host name."
}

variable "esxi_hostport" {
  description = "ESXI server port."
  default     = "22"
}

variable "esxi_hostssl" {
  description = "ESXI server SSH port."
  default     = "443"
}

variable "esxi_username" {
  description = "ESXI server user name."
  default     = "root"
}

variable "esxi_password" { # Unspecified will prompt
  description = "ESXI server password."
}
#
#   Use of variables here to hide/move the variables to a separate file
#
provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}
