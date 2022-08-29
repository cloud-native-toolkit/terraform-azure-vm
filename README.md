# Azure Virtual Machine

## Module Overview

Module creates an Azure a virtual machine. It includes the following resources:
- random_password
- tls_private_key
- azurerm_network_interface
- azurerm_public_ip
- azurerm_linux_virtual_machine
- azurerm_windows_virtual_machine

### Software dependencies

- terraform >= 1.2.6

### Terraform providers

- Azure provider >= 3.0.0

### Module dependencies

This modules makes use of the output from other modules:
- Azure Resource Group - github.com/cloud-native-toolkit/terraform-azure-resource-group
- Azure VNet - github.com/cloud-native-toolkit/terraform-azure-vnet
- Azure Subnets - github.com/cloud-native-toolkit/terraform-azure-subnets

## Example Usage

```hcl-terraform
module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group"

  resource_group_name = "mytest-rg"
  region              = var.region
}

module "vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vnet"

  name_prefix         = "mytest"
  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  address_prefixes    = ["10.0.0.0/18"]
}

module "subnets" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  vnet_name           = module.vnet.name
  ipv4_cidr_blocks    = ["10.0.0.0/24"]
  acl_rules           = []
}

module "vm" {
  source               = "github.com/cloud-native-toolkit/terraform-azure-vm"
  
  name_prefix         = "mytest-vm"
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnets.id
}
```

## Variables

### Inputs

This module has the following input variables:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| resource_group_name | Mandatory |  | The resource group to which to associate the NAT gateway  |
| name_prefix | Mandatory | | Name to prefix the created resources |
| subnet_id | Mandatory | | The id of the subnet to which to associate the virtual machine | 
| machine_type | Optional | Linux | The type of VM to create - Linux or Windows |
| use_ssh | Optional | true | Flag to use SSH only access or not for Linux VMs |
| pub_ssh_key | Optional | \"\" | Public SSH key to use for Linux access. Leave blank to create a new one (key pair will be stored in terraform working directory and named with provided prefix) |
| public | Optional | true | Flag to indicate if VM should have a public IP allocated |
| private_ip_address_allocation_type | Optional | Dynamic | The Azure subnet private IP allocation type - Dynamic or Static |
| vm_size | Optional | Standard_F2 | Azure machine size |
| admin_username | Optional | adminuser | Name to assign as the administrator user |
| bootstrap_script | Optional | Linux - ./templates/linux_user-data.sh Windows - ./templates/win_user-data | Path to file with bootstrap script |
| storage_type | Optional | Standard_LRS | Storage account type |


The following variables are used for Linux VMs:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| linux_image_publisher | Optional | Canonical | Linux image publisher |
| linux_image_offer | Optional | UbuntuServer | Linux OS image source offer |
| linux_image_sku | Optional | 18.04-LTS | Linux OS image SKU |
| linux_image_version | Optional | latest | Linux OS image verison |

The following variables are used for Windows VMs:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| win_image_publisher | Optional | MicrosoftWindowsServer | Linux image publisher |
| win_image_offer | Optional | WindowsServer | Linux OS image source offer |
| win_image_sku | Optional | 2016-Datacenter | Linux OS image SKU |
| win_image_version | Optional | latest | Linux OS image verison |

### Outputs

The module outputs the following values:
| Output | Description |
| -------------------------------- | -------------------------------------------------------------------------- |
| id | The Id of the deployed virtual machine |
| vm_public_ip | The address of the public IP if created |
| vm_public_fqdn | The FQDN of the public IP if created |
| vm_private_ip | The address of the VM on the supplied subnet |
| admin_username | The name of the administrator username |
| admin_password | For Windows or if not using SSH with Linux, the created administrator password (sensitive) |
