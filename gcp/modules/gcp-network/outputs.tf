output "subnetwork_id" {
  value       = google_compute_subnetwork.subnetwork.id
}
output "subnetwork_name" {
  value       = google_compute_subnetwork.subnetwork.name
}
output "subnetwork_cidr" {
  value       = google_compute_subnetwork.subnetwork.ip_cidr_range
}
output "network_id" {
  value       = google_compute_network.network.id
}
