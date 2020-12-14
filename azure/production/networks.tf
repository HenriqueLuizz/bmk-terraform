resource "azurerm_network_interface" "bkm_protheus_nic_01" {
    name                            = "${var.prefix}-NIC-SEC01"
    location                        = var.resource_location
    resource_group_name             = var.resource_name
    enable_accelerated_networking   = true
    
    ip_configuration {
        name                            = "secconfig1"
        subnet_id                       = "/subscriptions/a698f16f-8773-40f5-a611-30eafb3d671c/resourceGroups/bmkprotheus/providers/Microsoft.Network/virtualNetworks/bmkprotheus-vnet/subnets/default"
        private_ip_address_allocation   = "Static"
        private_ip_address              = "10.0.0.101"
    }
}

resource "azurerm_network_interface" "bkm_protheus_nic_02" {
    name                            = "${var.prefix}-NIC-SEC02"
    location                        = var.resource_location
    resource_group_name             = var.resource_name
    enable_accelerated_networking   = true
    
    ip_configuration {
        name                            = "secconfig1"
        subnet_id                       = "/subscriptions/a698f16f-8773-40f5-a611-30eafb3d671c/resourceGroups/bmkprotheus/providers/Microsoft.Network/virtualNetworks/bmkprotheus-vnet/subnets/default"
        private_ip_address_allocation   = "Static"
        private_ip_address              = "10.0.0.102"
    }
}
