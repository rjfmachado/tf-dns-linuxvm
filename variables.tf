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


