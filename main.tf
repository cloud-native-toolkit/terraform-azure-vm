provider "azurerm" {
  features {}
}

# resource "azurerm_resource_group" "example" {
#   name     = "${var.prefix}-resources"
#   location = "West Europe"
# }

# resource "azurerm_virtual_network" "main" {
#   name                = "${var.prefix}-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
# }

# resource "azurerm_subnet" "internal" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.main.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

resource "azurerm_network_interface" "network_interface" {
  name                = var.network_interface_name
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}

resource "azurerm_virtual_machine" "virtual_machine" {
  name                  = var.virtual_machine_name
  location              = var.region
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.network_interface.id]
  vm_size               = var.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = var.delete_data_disks_on_termination

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  storage_image_reference {
    publisher = var.storage_image_reference_publisher
    offer     = var.storage_image_reference_offer
    sku       = var.storage_image_reference_sku
    version   = var.storage_image_reference_version
  }
  storage_os_disk {
    name              = var.storage_os_disk_name
    caching           = var.storage_os_disk_caching
    create_option     = var.storage_os_disk_create_option
    managed_disk_type = var.storage_os_disk_managed_disk_type
  }
  os_profile {
    computer_name  = var.os_profile_computer_name
    admin_username = var.os_profile_admin_username
    admin_password = var.os_profile_admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = var.os_profile_linux_config_disable_password_authentication
  }

}