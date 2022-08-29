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

output "admin_username" {
  depends_on = [
    data.azurerm_virtual_machine.vm
  ]
  value = var.admin_username
}

output "admin_password" {
  depends_on = [
    data.azurerm_virtual_machine.vm
  ]
  value = random_password.vm-password.result
  sensitive = true
}
