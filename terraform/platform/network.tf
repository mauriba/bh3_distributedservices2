resource "azurerm_resource_group" "platform_network" {
  name = "rg-platform-network-${var.stage}-01"
  location = var.location
}

resource "azurerm_network_security_group" "platform" {
  name = "nsg-snet-192-168-20-0-24-platform"
  location = azurerm_resource_group.platform_network.location
  resource_group_name = azurerm_resource_group.platform_network.name
}

# region platform network security rules
resource "azurerm_network_security_rule" "allow_outbound_internet" {
  name = "allow-outbound-internet"
  resource_group_name = azurerm_resource_group.platform_network.name
  network_security_group_name = azurerm_network_security_group.platform.name
  priority = 200
  direction = "Outbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "*"
  destination_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name = "deny_all_inbound"
  resource_group_name = azurerm_resource_group.platform_network.name
  network_security_group_name = azurerm_network_security_group.platform.name
  priority = 300
  direction = "Inbound"
  access = "Deny"
  protocol = "*"
  source_port_range = "*"
  destination_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "*"
}
# endregion

resource "azurerm_virtual_network" "platform" {
  name = "vnet-192-168-20-0-24-${var.location}"
  location = azurerm_resource_group.platform_network.location
  resource_group_name = azurerm_resource_group.platform_network.name
  address_space = ["192.168.20.0/24"]
  # TODO : Add DNS servers
  dns_servers = []

  subnet {
    name = "snet-192-168-20-0-24-platform"
    address_prefixes = ["192.168.20.0/24"]
    security_group = azurerm_network_security_group.platform.id
  }
}
