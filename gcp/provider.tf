terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.44.0"
    }
  }
}

provider "google" {
  project     = "teste-de-carga-do-protheus"
  credentials = file("${path.module}/secrets/${var.secretfile}")
  region      = "us-central1"
}
