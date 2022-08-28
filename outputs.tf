output "id" {
  value = data.azurerm_virtual_machine.vm.id
}

output "vm_public_ip" {
  value = data.azurerm_virtual_machine.vm.public_ip_address
}

output "vm_private_ip" {
  value = data.azurerm_virtual_machine.vm.private_ip_address
}

output "vm_public_fqdn" {
  value = azurerm_public_ip.vm_public_ip[0].fqdn
}
