resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.name}"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "ipconfig-${var.name}"
    subnet_id                     = var.subnetid
    private_ip_address_allocation = "Dynamic"
  }
}

data "template_file" "cloudconfig" {
  template = file("${path.module}/dns.tpl")
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudconfig.rendered
  }
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

  custom_data = data.template_cloudinit_config.config.rendered

  admin_ssh_key {
    username   = var.adminuser
    public_key = file("~/.ssh/id_rsa.pub")
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
