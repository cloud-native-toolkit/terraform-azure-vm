variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group where the VM is to be provisioned. The VM will be provisioned in the same location as the resource group."
}

variable "subnet_id" {
  type        = string
  description = "The Azure subnet id to which to attach the virtual machine private NIC"
}

variable "machine_type" {
  type = string
  description = "The type of VM to create - \"Linux\" or \"Windows\" (default = \"Linux\")"
  default = "Linux"
}

variable "name_prefix" {
  type        = string
  description = "Name to prefix resources created"
}

variable "pub_ssh_key" {
  type = string
  description = "Public SSH key for VM access. Provide an empty variable for windows VMs as it is not used."
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

// Linux OS image properties
variable "linux_image_publisher" {
  type = string
  description = "Linux image publisher name (default = \"Canonical\")"
  default = "Canonical"
}

variable "linux_image_offer" {
  type = string
  description = "Linux OS image source offer (default = \"UbuntuServer\")"
  default = "UbuntuServer"
}

variable "linux_image_sku" {
  type = string
  description = "Linux OS image SKU (defualt = \"16.04-LTS\")"
  default = "16.04-LTS"
}

variable "linux_image_version" {
  type = string
  description = "Linux OS image version (default = \"latest\")"
  default = "latest"
}

// Windows OS image properties
variable "win_image_publisher" {
  type = string
  description = "Windows image publisher name (default = \"Canonical\")"
  default = "MicrosoftWindowsServer"
}

variable "win_image_offer" {
  type = string
  description = "Windows OS image source offer (default = \"UbuntuServer\")"
  default = "WindowsServer"
}

variable "win_image_sku" {
  type = string
  description = "Windows OS image SKU (defualt = \"16.04-LTS\")"
  default = "2016-Datacenter"
}

variable "win_image_version" {
  type = string
  description = "Windows OS image version (default = \"latest\")"
  default = "latest"
}
