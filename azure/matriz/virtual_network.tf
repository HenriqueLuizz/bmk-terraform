# resource "azurerm_proximity_placement_group" "bmk_protheus_ppg" {
#     name                    = "bmkProximityPlacementGroup"
#     location                = var.resource_location
#     resource_group_name     = var.resource_name

#     tags = {
#         environment = "Production"
#     }
# }

# resource "azurerm_virtual_network" "bmk_protheus_vn" {
#     name                    = "bmk-network"
#     address_space           = ["10.0.0.0/16"]
#     location                = var.resource_location
#     resource_group_name     = var.resource_name
# }

# resource "azurerm_subnet" "bmk_protheus_subnet" {
#     name                    = "internal"
#     resource_group_name     = var.resource_name
#     # virtual_network_name    = azurerm_virtual_network.bmk_protheus_vn.name
#     virtual_network_name    = "bmkprotheus-vnet"
#     address_prefix          = "10.0.1.0/24"
# }

resource "azurerm_public_ip" "bmk_protheus_pip" {
    name                    = "${var.prefix}MATRIZ-PIP"
    location                = var.resource_location
    resource_group_name     = var.resource_name
    sku                     = "Standard"
    allocation_method       = "Static"
    ip_version              = "IPv4"
    idle_timeout_in_minutes = 30

    tags = {
        environment = "Production"
    }
}

resource "azurerm_network_interface" "bkm_protheus_nic" {
    name                            = "${var.prefix}-nic-01"
    location                        = var.resource_location
    resource_group_name             = var.resource_name
    enable_accelerated_networking   = true
    
    ip_configuration {
        name                            = "matrizconfig1"
        #Todo: Change Subnet_id -
        subnet_id                       = "/subscriptions/a698f16f-8773-40f5-a611-30eafb3d671c/resourceGroups/bmkprotheus/providers/Microsoft.Network/virtualNetworks/bmkprotheus-vnet/subnets/default"
        public_ip_address_id            = azurerm_public_ip.bmk_protheus_pip.id
        private_ip_address_allocation   = "Static"
        private_ip_address              = "10.0.0.100"
        # private_ip_address_allocation   = "Dynamic"
        # subnet_id                       = azurerm_subnet.bmk_protheus_subnet.id
    }
}

resource "azurerm_network_security_group" "bmk_protheus_sg" {
    name                    = "acceptanceTestResourceGroup1"
    location                = var.resource_location
    resource_group_name     = var.resource_name

    #Todo: Add Defaults Rules
    security_rule {
        name                        = "allowAllPorts"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
    }

    tags = {
        environment = "Production"
    }
}

resource "azurerm_network_interface_security_group_association" "bmk_protheus_sga" {
    network_interface_id            = azurerm_network_interface.bkm_protheus_nic.id
    network_security_group_id       = azurerm_network_security_group.bmk_protheus_sg.id
}

# data "azurerm_public_ip" "bmk_protheus_pip" {
#     name    = azurerm_public_ip.bmk_protheus_pip.name
#     resource_group_name     = azurerm_resource_group.bmk_protheus_group.name
# }
# output public_ip_address_matriz {
#   value       = data.azurerm_public_ip.bmk_protheus_pip.ip_address
# }
