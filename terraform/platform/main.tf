resource "azurerm_resource_group" "terminalserver" {
  name     = "rg-terminalserver-${var.stage}-01"
  location = var.location
}

resource "azurerm_resource_group" "platform_network" {
  name     = "rg-platform-network-${var.stage}-01"
  location = var.location
}

resource "azurerm_network_security_group" "platform" {
  name                = "nsg-snet-192-168-20-0-24-platform"
  location            = azurerm_resource_group.platform_network.location
  resource_group_name = azurerm_resource_group.platform_network.name

  security_rule {
    name                       = "allow-all-outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny_all_inbound"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-ping-inbound"
    priority                   = 290
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "platform" {
  name                = "vnet-192-168-20-0-24-${var.location}"
  location            = azurerm_resource_group.platform_network.location
  resource_group_name = azurerm_resource_group.platform_network.name
  address_space       = ["192.168.20.0/24"]
  # TODO : Add DNS servers
  dns_servers = []

}

resource "azurerm_subnet" "platform" {
  name                 = "snet-192-168-20-0-24-platform"
  resource_group_name  = azurerm_resource_group.platform_network.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = ["192.168.20.0/24"]
}
