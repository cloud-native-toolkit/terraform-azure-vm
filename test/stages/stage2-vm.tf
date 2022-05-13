module "dev_tools_mymodule" {
source = "./module"
resource_group_name         = module.resource_group.name
region                      = var.region
virtual_network_name =module.vnet.name
network_interface_name="isl-ahm-nic"
ip_configuration_name="testConfiguration"
subnet_id="/subscriptions/bc1627c6-ec80-4da3-8d18-03e91330e2f1/resourceGroups/rg-isl-ahm1/providers/Microsoft.Network/virtualNetworks/example-network/subnets/subnet1"
private_ip_address_allocation="Dynamic"
virtual_machine_name="isl-ahm-vm1"
vm_size="Standard_DS1_v2"
storage_image_reference_publisher="Canonical"
storage_image_reference_offer="UbuntuServer"
storage_image_reference_sku="16.04-LTS"
storage_image_reference_version="latest"
storage_os_disk_name="myosdisk1"
storage_os_disk_caching="ReadWrite"
storage_os_disk_create_option="FromImage"
storage_os_disk_managed_disk_type="Standard_LRS"
os_profile_computer_name="hostname"
os_profile_admin_username="testadmin"
os_profile_admin_password="Password1234!"
 
}
