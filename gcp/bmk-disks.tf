module gcp-disk {
  count = var.instances
  source = "./modules/gcp-disk"
  prefix = "bmk"
  name  = "disk${count.index}"
  type  = var.disk_type
  zone  = var.zone
  size  = var.matriz_disk_data_size
#   image = "debian-9-stretch-v20200805"
  label = "prod"
}

module gcp-primary-disk {
  source = "./modules/gcp-disk"
  prefix = "bmk"
  name  = "disk00"
  type  = var.disk_type
  zone  = var.zone
  size  = var.primary_disk_data_size
#   image = "debian-9-stretch-v20200805"
  label = "prod"
}