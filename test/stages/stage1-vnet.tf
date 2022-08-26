module "vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vnet"

  resource_group_name = module.resource_group.name
  region              = var.region
  name_prefix         = local.name_prefix
  address_prefix_count = 1
  address_prefixes    = ["${var.vnet_cidr}"]
  enabled             = true
}
