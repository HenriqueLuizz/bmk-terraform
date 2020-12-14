resource "azurerm_virtual_machine" "bmk_handson_win_replica_01" {
    name                            = "${var.prefix}-win-secondary01"
    location                        = var.resource_location
    resource_group_name             = var.resource_name
    network_interface_ids           = [ azurerm_network_interface.bkm_protheus_nic_01.id ]
    vm_size                         = "Standard_DS4_v2"
    
    delete_os_disk_on_termination   = true
    delete_data_disks_on_termination = true
    
    proximity_placement_group_id    = "/subscriptions/a698f16f-8773-40f5-a611-30eafb3d671c/resourceGroups/bmkprotheus/providers/Microsoft.Compute/proximityPlacementGroups/bmkprotheus"
    
    storage_image_reference {
        # source_image_id = data.azurerm_image.search.id
        id = "/subscriptions/a698f16f-8773-40f5-a611-30eafb3d671c/resourceGroups/bmkprotheus/providers/Microsoft.Compute/images/BMK-protheus-image-v1"
    }

    storage_os_disk {
        name                = "${var.prefix}SEC01-OS"
        caching             = "ReadWrite"
        managed_disk_type   = "StandardSSD_LRS"
        create_option       = "FromImage"
        disk_size_gb        = 128
    }

    os_profile {
        computer_name   = "${var.prefix}SECI"
        admin_username  = "handson"
        admin_password  = "totvs@TOTVS123"
    }

    os_profile_windows_config {
        enable_automatic_upgrades = false
    }

}

resource "azurerm_virtual_machine" "bmk_handson_win_replica_02" {
    name                            = "${var.prefix}-win-secondary02"
    location                        = var.resource_location
    resource_group_name             = var.resource_name
    network_interface_ids           = [ azurerm_network_interface.bkm_protheus_nic_02.id ]
    vm_size                         = "Standard_DS4_v2"
    
    delete_os_disk_on_termination   = true
    delete_data_disks_on_termination = true
    
    proximity_placement_group_id    = "/subscriptions/a698f16f-8773-40f5-a611-30eafb3d671c/resourceGroups/bmkprotheus/providers/Microsoft.Compute/proximityPlacementGroups/bmkprotheus"
    
    storage_image_reference {
        # source_image_id = data.azurerm_image.search.id
        id = "/subscriptions/a698f16f-8773-40f5-a611-30eafb3d671c/resourceGroups/bmkprotheus/providers/Microsoft.Compute/images/BMK-protheus-image-v1"
    }

    storage_os_disk {
        name                = "${var.prefix}SEC02-OS"
        caching             = "ReadWrite"
        managed_disk_type   = "StandardSSD_LRS"
        create_option       = "FromImage"
        disk_size_gb        = 128
    }

    os_profile {
        computer_name   = "${var.prefix}SECII"
        admin_username  = "handson"
        admin_password  = "123@321#123"
    }

    os_profile_windows_config {
        enable_automatic_upgrades = false
    }

}
