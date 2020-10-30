module gcp-network {
  source = "./modules/gcp-network"

  prefix      = "bmk"
  region      = "us-central1"
  zone        = "us-central1-c"
  ports_allow = ["8080", "5432", "443", "5555", "10000-10020", "7890", "7900-7902", "9090"]

}
