resource "google_compute_subnetwork" "subnetwork" {
  name          = "${var.prefix}-subnetwork"
  ip_cidr_range = "10.2.0.0/24"
  region        = var.region
  network       = google_compute_network.network.id
}

resource "google_compute_network" "network" {
  name = "${var.prefix}-network"
  description = "VPC Network"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "firewall" {
    name = "${var.prefix}-firewall"
    network = google_compute_network.network.id

    allow {
        protocol = "tcp"
        ports = var.ports_allow
    }

    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default" {
    name = "${var.prefix}-default"
    network = google_compute_network.network.id

    allow {
        protocol = "tcp"
        ports = ["3389", "22"]
    }

    source_ranges = ["0.0.0.0/0"]
}