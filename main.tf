locals {
  net_if_name     = "${var.name_prefix}-nic"
  ip_config_name  = "${var.name_prefix}-ip-config"
  vm_name         = "${var.name_prefix}-vm"
  os_disk_name    = "${var.name_prefix}-osdisk"
  public_ip_name  = "${var.name_prefix}-pip"
  key_name        = "${var.name_prefix}-key"

  bootstrap_script = var.bootstrap_script == "" ? var.machine_type == "Linux" ? "${path.module}/templates/linux_user-data.sh" : "${path.module}/templates/win_user-data" : var.bootstrap_script
}

// Create a random admin password
resource "random_password" "vm-password" {
  length            = 16
  min_upper         = 2
  min_lower         = 2
  min_special       = 4
  min_numeric       = 2
  override_special  = "-#$%@"
}

// Create ssh key for linux if not provided
resource "tls_private_key" "key" {
    count     = var.pub_ssh_key == "" ? 1 : 0

    algorithm = "RSA"
    rsa_bits  = "4096"
}

resource "local_file" "private_key" {
    count           = var.pub_ssh_key == "" ? 1 : 0

    content         = tls_private_key.key[0].private_key_pem
    filename        = "${path.cwd}/${local.key_name}"
    file_permission = var.file_permissions
}

resource "local_file" "public_key" {
    count           = var.pub_ssh_key == "" ? 1 : 0
    
    content         = tls_private_key.key[0].public_key_openssh
    filename        = "${path.cwd}/${local.key_name}.pub"
    file_permission = var.file_permissions
}

data "local_file" "pub_key" {
    depends_on = [
      local_file.public_key
    ]

    filename        = "${path.cwd}/${local.key_name}.pub"
}

// Get resource group details
data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

// Create private only NIC if required
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

// Create public IP and public NIC if required
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

// Read the NIC info for whichever one was required (public or private)
data "azurerm_network_interface" "vm_nic" {
  name = var.public ? azurerm_network_interface.public[0].name : azurerm_network_interface.private[0].name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

// Linux VM

resource "azurerm_linux_virtual_machine" "vm-ssh" {
  count = var.machine_type == "Linux" && var.use_ssh ? 1 : 0

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
    public_key  = var.pub_ssh_key == "" ? file(data.local_file.pub_key.content) : var.pub_ssh_key
  }

  os_disk {
    name                  = local.os_disk_name
    caching               = "ReadWrite"
    storage_account_type  = var.storage_type
  }

  source_image_reference {
    publisher = var.linux_image_publisher
    offer     = var.linux_image_offer
    sku       = var.linux_image_sku
    version   = var.linux_image_version
  }
}

resource "azurerm_linux_virtual_machine" "vm-pwd" {
  count = var.machine_type == "Linux" && ! var.use_ssh ? 1 : 0

  name                = local.vm_name
  computer_name       = local.vm_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = random_password.vm-password.result
  custom_data         = base64encode(templatefile(local.bootstrap_script,{}))

  network_interface_ids = [
    data.azurerm_network_interface.vm_nic.id
  ]

  os_disk {
    name                  = local.os_disk_name
    caching               = "ReadWrite"
    storage_account_type  = var.storage_type
  }

  source_image_reference {
    publisher = var.linux_image_publisher
    offer     = var.linux_image_offer
    sku       = var.linux_image_sku
    version   = var.linux_image_version
  }
}


// Windows VM

resource "azurerm_windows_virtual_machine" "vm" {
  count = var.machine_type == "Windows" ? 1 : 0
  
  name                = local.vm_name
  computer_name       = local.vm_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = random_password.vm-password.result
  custom_data         = base64encode(templatefile(local.bootstrap_script,{}))
  network_interface_ids = [
    data.azurerm_network_interface.vm_nic.id
  ]

  os_disk {
    caching               = "ReadWrite"
    storage_account_type  = var.storage_type
  }

  source_image_reference {
    publisher = var.win_image_publisher
    offer     = var.win_image_offer
    sku       = var.win_image_sku
    version   = var.win_image_version
  }
}

data "azurerm_virtual_machine" "vm" {
  name                = var.machine_type == "Linux" ? var._use_ssh ? azurerm_linux_virtual_machine.vm-ssh[0].name : azurerm_linux_virtual_machine.vm-pwd[0].name : azurerm_windows_virtual_machine.vm[0].name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

// Data disks
# resource "azurerm_virtual_machine_data_disk_attachment" "data_disks" {
  
# }