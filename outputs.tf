
output "vm_public_ip" {
  value = azurerm_public_ip.vm_public_ip[0].ip_address
}

output "vm_public_fqdn" {
  value = azurerm_public_ip.vm_public_ip[0].fqdn
}
