resource "google_project" "this" {
  project_id      = var.project_id
  name            = var.project_name
  billing_account = var.billing_account
  folder_id       = regex("folders/(.+)$", var.folder_name)[0]
}

resource "google_project_service" "core" {
  for_each = toset([
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ])

  project = google_project.this.project_id
  service = each.value
}

# Add a time delay to ensure APIs are fully propagated
resource "time_sleep" "wait_for_apis" {
  depends_on = [google_project_service.core]

  create_duration = "60s"
}

resource "google_compute_shared_vpc_host_project" "host" {
  project = google_project.this.project_id

  depends_on = [
    time_sleep.wait_for_apis
  ]
}

module "networking" {
  source = "../../modules/networking"

  project_id  = google_project.this.project_id
  region      = var.region
  environment = var.environment

  # hub NP CIDRs
  vpc_cidr      = "10.0.0.0/20"
  pods_cidr     = "10.0.16.0/20"
  services_cidr = "10.0.32.0/20"

  depends_on = [
    time_sleep.wait_for_apis
  ]
}

output "project_id" {
  value = google_project.this.project_id
}

output "network_name" {
  value = module.networking.network_name
}

output "network_id" {
  value = module.networking.network_id
}

output "subnet_name" {
  value = module.networking.subnet_name
}

output "pods_range_name" {
  value = module.networking.pods_range_name
}

output "services_range_name" {
  value = module.networking.services_range_name
}
