resource "azurerm_public_ip" "linuxservice" {
  count               = var.enable_public_ip == false ? 0 : 1
  name                = "pip-vm-${var.hostname}"
  resource_group_name = var.subnet.resource_group_name
  allocation_method   = "Dynamic"
  location            = var.subnet.location
}

resource "azurerm_network_interface" "linuxservice" {
  name                = "nic-vm-${var.hostname}"
  resource_group_name = var.subnet.resource_group_name
  location            = var.subnet.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet.id
    private_ip_address_allocation = var.private_ip != null ? "Static" : "Dynamic"
    private_ip_address            = var.private_ip != null ? var.private_ip : null
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.linuxservice.id : null
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                            = "vm-${var.hostname}"
  resource_group_name             = var.subnet.resource_group_name
  location                        = var.subnet.location
  size                            = "Standard_B2s"
  admin_username                  = "loc_sysadmin"
  disable_password_authentication = false
  admin_password                  = var.password
  network_interface_ids = [
    azurerm_network_interface.linuxservice.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.image.publisher
    offer     = var.image.offer
    sku       = var.image.sku
    version   = var.image.version
  }
}
