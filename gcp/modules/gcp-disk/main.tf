resource "google_compute_disk" "disk" {
  name  = "${var.prefix}-${var.name}"
  type  = var.type
  zone  = var.zone
  size  = var.size

  image = var.image
  labels = {
    environment = var.label
  }
  physical_block_size_bytes = 4096
}