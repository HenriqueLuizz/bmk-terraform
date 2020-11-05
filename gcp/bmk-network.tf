module gcp-network {
  source = "./modules/gcp-network"

  prefix      = "bmk"
  region      = "us-central1"
  zone        = "us-central1-c"
  ports_allow =  ["8080", 
                  "5432", 
                  "443", 
                  "5555", 
                  "10000-10020", 
                  "7890", 
                  "7900-7902",
                  "9090",
                  "5356", 
                  "7", 
                  "88",
                  "135",
                  "139",
                  "389",
                  "445",
                  "53",
                  "389",
                  "5432",
                  "1433",
                  "49152-65535"]
}

resource "google_compute_firewall" "firewall_win" {
    name = "bmk-firewall-win"
    network = module.gcp-network.network_id

    allow {
        protocol = "udp"
        ports = [
          "137",
          "138"          
        ]
    }

    source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "firewall_icmp" {
    name = "bmk-firewall-icmp"
    network = module.gcp-network.network_id

    allow {
        protocol = "icmp"
    }

    source_ranges = ["0.0.0.0/0"]
}