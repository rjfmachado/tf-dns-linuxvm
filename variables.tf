variable "rg" {
  type = string
}

variable "name" {
  type = string
}

variable "adminuser" {
  type    = string
  default = "ricardma"
}

variable "sshkey" {
  type    = string
  default = ""
  //will load ~/.ssh/id_rsa.pub by default
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "size" {
  type    = string
  default = "Standard_B1s"
}

variable "storage_type" {
  type    = string
  default = "Premium_LRS"
}

variable "subnetid" {
}

variable "ipaddress" {
  type = string
}

variable "staticip" {
  type    = bool
  default = true
}

variable "cloud-config" {
  type    = string
  default = "dns.tpl"
}

variable "zone" {
  type    = string
  default = "1"
}
