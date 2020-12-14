resource "azurerm_virtual_machine_data_disk_attachment" "bmk_appdisk_attachment01" {
    managed_disk_id     = azurerm_managed_disk.bmk_appdisk01.id
    virtual_machine_id  = azurerm_virtual_machine.bmk_handson_win_replica_01.id
    lun                 = 0
    caching             = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "bmk_appdisk_attachment02" {
    managed_disk_id     = azurerm_managed_disk.bmk_appdisk02.id
    virtual_machine_id  = azurerm_virtual_machine.bmk_handson_win_replica_02.id
    lun                 = 0
    caching             = "ReadWrite"
}
