output "network_interface" {
  value = azurerm_network_interface.linuxservice
}

output "virtual_machine" {
  value = azurerm_linux_virtual_machine.linuxservice
}
