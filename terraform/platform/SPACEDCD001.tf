module "domaincontroller" {
  source           = "../../modules/linuxservice"
  subnet           = azurerm_subnet.platform
  resource_group   = azurerm_resource_group.terminalserver
  hostname         = "SPACEDCD001"
  private_ip       = "192.168.20.5"
  password         = var.password
}
