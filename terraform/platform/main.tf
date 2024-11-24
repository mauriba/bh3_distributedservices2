resource "azurerm_resource_group" "terminalserver" {
  name = "rg-terminalserver-${var.stage}-01"
  location = var.location
}

module "terminalserver" {
  source = "../../modules/linuxservice"
  subnet = azurerm_subnet.platform
  resource_group = azurerm_resource_group.terminalserver
  hostname = "SPACETSP001"
  private_ip = "192.168.20.4"
  password = var.password
  enable_public_ip = true
}
