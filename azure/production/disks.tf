resource "azurerm_managed_disk" "bmk_appdisk01" {
    name                    = "${var.prefix}-sec01-appdisk"
    location                = var.resource_location
    resource_group_name     = var.resource_name
    storage_account_type    = "StandardSSD_LRS"
    create_option           = "Copy"
    disk_size_gb            = "256"
    source_resource_id      = "/subscriptions/a698f16f-8773-40f5-a611-30eafb3d671c/resourceGroups/BMKPROTHEUS/providers/Microsoft.Compute/disks/BMKPROTHEUS-SEC01_disk2_8cf232bb19404a95981ffd8c8de1f0ab"
}

resource "azurerm_managed_disk" "bmk_appdisk02" {
    name                    = "${var.prefix}-sec02-appdisk"
    location                = var.resource_location
    resource_group_name     = var.resource_name
    storage_account_type    = "StandardSSD_LRS"
    create_option           = "Copy"
    disk_size_gb            = "256"
    source_resource_id      = "/subscriptions/a698f16f-8773-40f5-a611-30eafb3d671c/resourceGroups/BMKPROTHEUS/providers/Microsoft.Compute/disks/BMKPROTHEUS-SEC01_disk2_8cf232bb19404a95981ffd8c8de1f0ab"
}
