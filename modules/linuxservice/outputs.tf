output "network_interface" {
  value = azurerm_network_interface.linuxservice
}

output "virtual_machine" {
  value = azurerm_linux_virtual_machine.linuxservice
}

output "hostname" {
  value = var.hostname
}

output "public_ip" {
  value = azurerm_public_ip.linuxservice[0].ip_address
}
