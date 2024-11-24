module "terminalserver" {
  source           = "../../modules/linuxservice"
  subnet           = azurerm_subnet.platform
  resource_group   = azurerm_resource_group.terminalserver
  hostname         = "SPACETSD001"
  private_ip       = "192.168.20.4"
  password         = var.password
  enable_public_ip = true
}

resource "azurerm_network_security_group" "terminalserver" {
  name                = "nsg-${module.terminalserver.hostname}"
  resource_group_name = azurerm_resource_group.terminalserver.name
  location            = azurerm_resource_group.terminalserver.location

  security_rule {
    name                       = "allow-ssh-from-internet"
    priority                   = 190
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    destination_address_prefix = module.terminalserver.network_interface.ip_configuration[0].private_ip_address
    source_address_prefix      = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "terminalserver" {
  network_interface_id      = module.terminalserver.network_interface.id
  network_security_group_id = azurerm_network_security_group.terminalserver.id
}
