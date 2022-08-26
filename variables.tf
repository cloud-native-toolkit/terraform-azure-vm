variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group where the NAT gateway has been provisioned"
}

variable "subnet_id" {
  type        = string
  description = "The Azure subnet id"
}

variable "machine_type" {
  type = string
  description = "The type of VM to create - Linux or Windows (default = \"Linux\")"
  default = "Linux"
}

variable "name_prefix" {
  type        = string
  description = "Name to prefix resources created"
}

variable "pub_ssh_key" {
  type = string
  description = "Public SSH key for VM access"
}

variable "public" {
  type = bool
  description = "Flag to indicate if VM shoudl have a public IP allocated (default = \"true\")"
  default = true
}

variable "private_ip_address_allocation_type" {
  type        = string
  description = "The Azure subnet private ip address alocation type - Dynamic or Static (default = \"Dynamic\")"
  default     = "Dynamic"
}

variable "vm_size" {
  type        = string
  description = "This is the size of Virtual Machine (defualt = \"Standard_F2\")"
  default     = "Standard_F2"
}

variable "admin_username" {
  type        = string
  description = "Username for the admin user (default = \"adminuser\")"
  default     = "adminuser"
}

variable "bootstrap_script" {
  type = string
  description = "Path to file with the bootstrap script (default = \"./template/user-data.sh\")"
  default = ""
}

variable "storage_type" {
  type        = string
  description = "Storage account type (default = \"Standard_LRS\")"
  default     = "Standard_LRS"
}

# variable "os_disk_size" {
#   type = bool
#   description = "Size of OS disk (default = \"100\"). Note this must be at least as large as the OS image"
#   default = 100
# }

// OS image properties
variable "image_publisher" {
  type = string
  description = "Image publisher name (default = \"Canonical\")"
  default = "Canonical"
}

variable "image_offer" {
  type = string
  description = "OS image source offer (default = \"UbuntuServer\")"
  default = "UbuntuServer"
}

variable "image_sku" {
  type = string
  description = "OS image SKU (defualt = \"16.04-LTS\")"
  default = "16.04-LTS"
}

variable "image_version" {
  type = string
  description = "OS image version (default = \"latest\")"
  default = "latest"
}
