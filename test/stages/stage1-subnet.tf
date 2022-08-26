module "subnets" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  vnet_name           = module.vnet.name
  ipv4_cidr_blocks    = [cidrsubnets(var.vnet_cidr, 2)]
  acl_rules = [{
    name        = "ssh-inbound"
    action      = "Allow"
    direction   = "Inbound"
    source      = "*"
    destination = "*"
    tcp = {
      port_min        = 22
      port_max        = 22
      source_port_min = 22
      source_port_max = 22
    }
    }, {
    name        = "vpn-inbound"
    action      = "Allow"
    direction   = "Inbound"
    source      = "*"
    destination = "*"
    udp = {
      port_min        = 1194
      port_max        = 1194
      source_port_min = 1194
      source_port_max = 1194
    }
  }]
}
