output "network_name" {
  description = "VPC network name"
  value       = google_compute_network.main.name
}

output "network_id" {
  description = "VPC network ID"
  value       = google_compute_network.main.id
}

output "subnet_name" {
  description = "GKE subnet name"
  value       = google_compute_subnetwork.gke.name
}

output "subnet_id" {
  description = "GKE subnet ID"
  value       = google_compute_subnetwork.gke.id
}

output "pods_range_name" {
  value = "pods"
}

output "services_range_name" {
  value = "services"
}
