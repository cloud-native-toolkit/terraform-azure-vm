// Default Linux VM with created SSH keys
module "linux-vm1" {
  source              = "./module"

  name_prefix         = "${local.name_prefix}1"
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnets.id
}

// Linux VM with supplied SSH keys
module "linux-vm2" {
  source              = "./module" 

  name_prefix         = "${local.name_prefix}2"
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnets.id
  pub_ssh_key         = module.test-keys.pub_key
  create_ssh          = false
}

// Linux VM without SSH login (password)
module "linux-vm3" {
  source              = "./module"

  name_prefix         = "${local.name_prefix}3"
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnets.id
  use_ssh             = false
}

 // Windows VM
module "win-vm" {
  source              = "./module"

  name_prefix         = "win1"    // Note limitation of 15 charactors for Windows hostnames
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnets.id
  machine_type        = "Windows"
}