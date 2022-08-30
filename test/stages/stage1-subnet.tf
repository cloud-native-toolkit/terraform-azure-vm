locals {
  subnet_cidr = cidrsubnets(var.vnet_cidr, 2)
}

module "subnets" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  vnet_name           = module.vnet.name
  ipv4_cidr_blocks    = ["${local.subnet_cidr[0]}"]
  acl_rules = [{
    name        = "ssh-inbound"
    action      = "Allow"
    direction   = "Inbound"
    source      = "*"
    destination = "*"
    tcp = {
      destination_port_range = "22"
      source_port_range = "*"
    }
    }, {
    name        = "rdp-inbound-tcp"
    action      = "Allow"
    direction   = "Inbound"
    source      = "*"
    destination = "*"
    tcp = {
      destination_port_range = "3389"
      source_port_range = "*"
    }
  }, {
    name        = "rdp-inbound-udp"
    action      = "Allow"
    direction   = "Inbound"
    source      = "*"
    destination = "*"
    udp = {
      destination_port_range = "3389"
      source_port_range = "*"
    }
  }]
}
