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

variable "cloud-config" {
  type    = string
  default = "dns.tpl"
}

variable "ipconfiguration" {
  type = object
  default = {
    name                          = "ipconfig-name"
    subnet_id                     = "subnetid"
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = ""
  }
}
