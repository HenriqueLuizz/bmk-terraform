resource "google_compute_instance" "primary" {
    name = "${var.prefix}-primary0"
    machine_type = var.instance_type
    zone = var.zone
    allow_stopping_for_update = true
    
    deletion_protection = true

    # depends_on = [ google_sql_database.database ]

    boot_disk {
        auto_delete = false
        initialize_params {
            image = var.image_disk
            size = var.disk_os_size
            type = var.disk_type
        }
    }

    scratch_disk {
        interface = "SCSI"
    }

    attached_disk {
        source  = module.gcp-primary-disk.self_link
        device_name = "data"
        mode    = "READ_WRITE"
    }

    network_interface {
        subnetwork = module.gcp-network.subnetwork_name
        network_ip = "10.2.0.2"
        access_config {}
    }

    metadata = {
        # sysprep-specialize-script-url = "gs://bmkprotheus/bmkstartup.ps1"
        windows-startup-script-url = "gs://bmkprotheus/bmkprimarystartup.ps1"
    }

    service_account {
        scopes = ["storage-full","https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/source.full_control"]
    }
}


# resource "google_compute_project_metadata_item" "default" {
#   key   = "teste"
#   value = "valor_#_teste"
# }