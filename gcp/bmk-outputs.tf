output primary_public_ip {
  value       = google_compute_instance.primary.network_interface.0.access_config.0.nat_ip
  description = "Primary Instance public ip"
  depends_on  = []
}

output secondary_public_ip {
  value       = google_compute_instance.secondary.*.network_interface.0.access_config.0.nat_ip
  description = "Secondary Instance public ip"
  depends_on  = []
}

output secondary_internal_ip {
  value       = google_compute_instance.secondary.*.network_interface.0.network_ip
  description = "Instance network ip"
  depends_on  = []
}

output primary_internal_ip {
  value       = google_compute_instance.primary.network_interface.0.network_ip
  description = "Primary network ip"
  depends_on  = []
}
