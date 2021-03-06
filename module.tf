resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.name}"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name      = "ipconfig-${var.name}"
    subnet_id = var.subnetid

    private_ip_address_allocation = var.staticip ? "Static" : "Dynamic"
    private_ip_address            = var.ipaddress
  }
}

data "template_file" "cloudconfig" {
  template = fileexists(var.cloud-config) ? file(var.cloud-config) : file("${path.module}/${var.cloud-config}")
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudconfig.rendered
  }
}

locals {
  sshpublickey = var.sshkey == "" ? file("~/.ssh/id_rsa.pub") : var.sshkey
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.name
  resource_group_name = var.rg
  location            = var.location
  size                = var.size
  admin_username      = var.adminuser
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  zone = var.zone

  custom_data = data.template_cloudinit_config.config.rendered

  admin_ssh_key {
    username   = var.adminuser
    public_key = local.sshpublickey
  }

  disable_password_authentication = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
