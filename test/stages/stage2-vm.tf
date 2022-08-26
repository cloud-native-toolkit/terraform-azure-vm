module "azure-vm" {
  source              = "./module"

  name_prefix         = "${var.name_prefix}-${random_string.cluster_id.result}-vm"
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnets.id
}
