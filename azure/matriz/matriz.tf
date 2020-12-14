resource "azurerm_virtual_machine" "bmk_protheus_win_matriz" {
    name                            = "${var.prefix}-matriz"
    location                        = var.resource_location
    resource_group_name             = var.resource_name # "bmkprotheus01"
    #Todo: Create NICs
    network_interface_ids           = [azurerm_network_interface.bkm_protheus_nic.id]
    #Todo: Var VM Size
    vm_size                         = "Standard_DS4_v2"
    
    delete_os_disk_on_termination   = true
    delete_data_disks_on_termination = true
    
    #Todo: Proximit Placement Group  
    # proximity_placement_group_id    = azurerm_proximity_placement_group.bmk_protheus_ppg.id
    proximity_placement_group_id    = "/subscriptions/a698f16f-8773-40f5-a611-30eafb3d671c/resourceGroups/bmkprotheus/providers/Microsoft.Compute/proximityPlacementGroups/bmkprotheus"
    
    #Uses images from existing Protheus Enviroment
    #TodoV2: Implement Script to create machine - Add Image
    # source_image_id = data.azurerm_image.search.id

    # Todov2: Linux Version 
    storage_image_reference {
        publisher   = "MicrosoftWindowsServer"
        offer       = "WindowsServer"
        sku         = "2019-Datacenter"
        version     = "latest"
    }

    storage_os_disk {
        name                = "${var.prefix}MATRIZ-OS"
        caching             = "ReadWrite"
        managed_disk_type   = "StandardSSD_LRS"
        create_option       = "FromImage"
        disk_size_gb        = 127
    }

    #Todo: Add OS Profile Vars
    os_profile {
        computer_name   = "${var.prefix}MATRIZ"
        admin_username  = "handson"
        admin_password  = "123@321#123"
    }

    os_profile_windows_config {
        enable_automatic_upgrades = false
    }
}

resource "azurerm_managed_disk" "bmk_appdisk" {
    name    = "${var.prefix}-matriz-appdisk"
    location                = var.resource_location
    resource_group_name     = var.resource_name # "bmkprotheus01"
    storage_account_type    = "StandardSSD_LRS" #Todo: Add Storage Account Variable
    create_option           = "Empty"
    disk_size_gb            = "256"
}

resource "azurerm_virtual_machine_data_disk_attachment" "bmk_appdisk_attachment" {
    managed_disk_id     = azurerm_managed_disk.bmk_appdisk.id
    virtual_machine_id  = azurerm_virtual_machine.bmk_protheus_win_matriz.id
    lun                 = 0
    caching             = "ReadWrite"
}
