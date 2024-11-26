module "terminalserver" {
  source           = "../../modules/linuxservice"
  subnet           = azurerm_subnet.platform
  resource_group   = azurerm_resource_group.terminalserver
  hostname         = "SPACETSD001"
  private_ip       = "192.168.20.4"
  password         = var.password
  enable_public_ip = true
}
