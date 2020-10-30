resource "google_compute_instance" "secondary" {
    count = var.instances
    name = "${var.prefix}-secondary${count.index}"
    machine_type = var.instance_type
    zone = var.zone
    allow_stopping_for_update = true

    boot_disk {
        initialize_params {
            image = var.image_disk
            size = var.disk_os_size
            type = var.disk_type
        }
    }

    attached_disk {
        source  = module.gcp-disk[count.index].self_link
        device_name = "data"
        mode    = "READ_WRITE"
    }

    network_interface {
        subnetwork = module.gcp-network.subnetwork_name
        
        network_ip = cidrhost(module.gcp-network.subnetwork_cidr, count.index + 10)
        access_config {}
    }

    metadata = {
        windows-startup-script-url = "gs://bmkprotheus/bmksecondarystartup.ps1"
    }

    service_account {
        scopes = ["storage-full","https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/source.full_control"]
    }
}