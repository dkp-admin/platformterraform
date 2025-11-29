resource "google_project" "this" {
  project_id      = var.project_id
  name            = var.project_name
  org_id          = var.org_id
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

resource "google_compute_shared_vpc_host_project" "host" {
  project = google_project.this.project_id
}

module "networking" {
  source = "../../modules/networking"

  project_id  = google_project.this.project_id
  region      = var.region
  environment = var.environment

  # hub PROD CIDRs (separate range from NP)
  vpc_cidr      = "10.20.0.0/20"
  pods_cidr     = "10.20.16.0/20"
  services_cidr = "10.20.32.0/20"
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
