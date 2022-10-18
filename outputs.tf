output "id" {
  value       = data.azurerm_virtual_machine.vm.id
  description = "Azure identification of created VM"
}

output "vm_public_ip" {
  value       = var.public ? data.azurerm_virtual_machine.vm.public_ip_address : ""
  description = "Public IP assigned to VM (if applicable)"
}

output "vm_private_ip" {
  value       = data.azurerm_virtual_machine.vm.private_ip_address
  description = "Private IP assigned to VM"
}

output "vm_public_fqdn" {
  value       = var.public ? azurerm_public_ip.vm_public_ip[0].fqdn : ""
  description = "FQDN of the VM if assigned a public IP"
}

output "admin_username" {
  depends_on = [
    data.azurerm_virtual_machine.vm
  ]
  value       = var.admin_username
  description = "Administrator username assigned to VM"
}

output "admin_password" {
  depends_on = [
    data.azurerm_virtual_machine.vm
  ]
  value       = var.use_ssh ? "" : random_password.vm-password[0].result
  sensitive   = true
  description = "Administrator password assigned to VM"
}
