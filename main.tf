locals {
  net_if_name = "${var.name_prefix}-nic"
  ip_config_name = "${var.name_prefix}-ip-config"
  vm_name = "${var.name_prefix}-vm"
  os_disk_name = "${var.name_prefix}-osdisk"
  public_ip_name = "${var.name_prefix}-pip"

  bootstrap_script = var.bootstrap_script == "" ? "${path.module}/templates/user-data.sh" : var.bootstrap_script
}

// Get resource group details
data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_network_interface" "private" {
  count = var.public ? 0 : 1

  name                = "${local.net_if_name}-private"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = local.ip_config_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation_type
  }
}

resource "azurerm_public_ip" "vm_public_ip" {
  count = var.public ? 1 : 0

  name = local.public_ip_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  allocation_method = "Static"
}

resource "azurerm_network_interface" "public" {
  count = var.public ? 1 : 0

  name                = "${local.net_if_name}-public"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = local.ip_config_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation_type
    public_ip_address_id          = azurerm_public_ip.vm_public_ip[0].id
  }
}

data "azurerm_network_interface" "vm_nic" {
  name = var.public ? azurerm_network_interface.public[0].name : azurerm_network_interface.private[0].name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_linux_virtual_machine" "vm" {
  count = var.machine_type == "Linux" ? 1 : 0

  name                = local.vm_name
  computer_name       = local.vm_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  size                = var.vm_size
  admin_username      = var.admin_username
  custom_data         = base64encode(templatefile(local.bootstrap_script,{}))

  network_interface_ids = [
    data.azurerm_network_interface.vm_nic.id
  ]

  admin_ssh_key {
    username    = var.admin_username
    public_key  = var.pub_ssh_key
  }

  os_disk {
    name                  = local.os_disk_name
    caching               = "ReadWrite"
    storage_account_type  = var.storage_type
    # disk_size_gb          = var.os_disk_size
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}
