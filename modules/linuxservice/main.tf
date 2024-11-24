resource "azurerm_public_ip" "linuxservice" {
  count               = var.enable_public_ip == false ? 0 : 1
  name                = "pip-vm-${var.hostname}"
  resource_group_name = var.resource_group.name
  allocation_method   = "Static"
  location            = var.resource_group.location
}

resource "azurerm_network_interface" "linuxservice" {
  name                = "nic-vm-${var.hostname}"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet.id
    private_ip_address_allocation = var.private_ip != null ? "Static" : "Dynamic"
    private_ip_address            = var.private_ip != null ? var.private_ip : null
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.linuxservice[0].id : null
  }
}

resource "azurerm_linux_virtual_machine" "linuxservice" {
  name                            = "vm-${var.hostname}"
  resource_group_name             = var.resource_group.name
  location                        = var.resource_group.location
  size                            = "Standard_B2s"
  admin_username                  = "loc_sysadmin"
  disable_password_authentication = false
  user_data                       = base64encode(templatefile("${path.module}/bootstrap.tftpl", { hostname = var.hostname }))
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

# Add auto shutdown schedules to save costs
resource "azurerm_dev_test_global_vm_shutdown_schedule" "linuxservice-3pm" {
  virtual_machine_id = azurerm_linux_virtual_machine.linuxservice.id
  location           = var.resource_group.location
  enabled            = true

  daily_recurrence_time = "1500"
  timezone              = "W. Europe Standard Time"

  notification_settings {
    enabled = false
  }
}
