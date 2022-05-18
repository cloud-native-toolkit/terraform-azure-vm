variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group where the NAT gateway has been provisioned"
}

variable "region" {
  type        = string
  description = "The Azure location where the NAT gateway will be installed"
}
variable "virtual_network_name" {
  type        = string
  description = "The Azure virtual network name"
}
variable "network_interface_name" {
  type        = string
  description = "The Azure location where the NAT gateway will be installed"
}

variable "ip_configuration_name" {
  type        = string
  description = "The Azure location where the NAT gateway will be installed"

}
variable "subnet_id" {
  type        = string
  description = "The Azure subnet id"
}
variable "private_ip_address_allocation" {
  type        = string
  description = "The Azure subnet private ip address alocation"
  default     = "Dynamic"
}
variable "virtual_machine_name" {
  type        = string
  description = "This is the name of Azure VM"

}
variable "vm_size" {
  type        = string
  description = "This is the size of Virtual Machine"

}
variable "delete_os_disk_on_termination" {
  type        = bool
  description = "Flag to delete os disk on termination"
  default     = true
}

variable "delete_data_disks_on_termination" {
  type        = bool
  description = "Flag to delete data disk on termination"
  default     = true
}
variable "storage_image_reference_publisher" {
  type        = string
  description = "This is the storage image refrence publisher"
}
variable "storage_image_reference_offer" {
  type        = string
  description = "This is the storage image refrence offer"
}
variable "storage_image_reference_sku" {
  type        = string
  description = "This is the storage image refrence sku"
}
variable "storage_image_reference_version" {
  type        = string
  description = "This is the storage image refrence version"
}
#Storage OS Disk Vairables
variable "storage_os_disk_name" {
  type        = string
  description = "This is the storage OS disk name"
}
variable "storage_os_disk_caching" {
  type        = string
  description = "This is the storage OS disk cashing"
}
variable "storage_os_disk_create_option" {
  type        = string
  description = "This is the storage OS disk create option"
}
variable "storage_os_disk_managed_disk_type" {
  type        = string
  description = "This is the storage OS disk managed disk type"
}
#OS Profile
variable "os_profile_computer_name" {
  type        = string
  description = "This is the storage OS Profile Computer Name"
}
variable "os_profile_admin_username" {
  type        = string
  description = "This is the storage OS Profile Admin Username"
}
variable "os_profile_admin_password" {
  type        = string
  description = "This is the storage OS Profile Passowrd"
  sensitive   = true
}
variable "os_profile_linux_config_disable_password_authentication" {
  type        = bool
  description = "Flag to disable password authentication"
  default     = false

}

