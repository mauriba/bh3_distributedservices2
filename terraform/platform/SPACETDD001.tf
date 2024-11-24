module "testdeployment" {
  source           = "../../modules/linuxservice"
  subnet           = azurerm_subnet.platform
  resource_group   = azurerm_resource_group.terminalserver
  hostname         = "SPACETDD001"
  private_ip       = "192.168.20.7"
  password         = var.password
}
