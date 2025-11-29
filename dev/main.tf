resource "google_project" "this" {
  project_id      = var.project_id
  name            = var.project_name
  billing_account = var.billing_account
  folder_id       = var.env_folder_id
}

resource "google_project_service" "core" {
  for_each = toset([
    # Core APIs
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    # GKE APIs
    "container.googleapis.com",
    # Cloud SQL APIs
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    # Secret Manager API
    "secretmanager.googleapis.com",
    # DNS API
    "dns.googleapis.com",
  ])

  project = google_project.this.project_id
  service = each.value
}

# Add a time delay to ensure APIs are fully propagated
resource "time_sleep" "wait_for_apis" {
  depends_on = [google_project_service.core]

  create_duration = "60s"
}
 
data "terraform_remote_state" "bootstrap" {
  backend = "gcs"

  config = {
    bucket = "bootstrap-tijarah-terraform-state"
    prefix = "terraform/state/bootstrap"
  }
}

resource "google_compute_shared_vpc_service_project" "this" {
  host_project    = data.terraform_remote_state.bootstrap.outputs.network_hub_np_project_id
  service_project = google_project.this.project_id

  depends_on = [
    time_sleep.wait_for_apis
  ]
}

module "gke_autopilot" {
  source = "../modules/gke-autopilot"

  project_id  = google_project.this.project_id
  region      = var.region
  environment = var.environment

  network_name        = data.terraform_remote_state.bootstrap.outputs.network_hub_np_network_name
  subnet_name         = data.terraform_remote_state.bootstrap.outputs.network_hub_np_subnet_name
  pods_range_name     = data.terraform_remote_state.bootstrap.outputs.network_hub_np_pods_range_name
  services_range_name = data.terraform_remote_state.bootstrap.outputs.network_hub_np_services_range_name

  enable_private_endpoint = false

  master_authorized_networks = [
    {
      cidr_block   = "0.0.0.0/0"  # tighten for real usage.
      display_name = "All networks"
    }
  ]

  depends_on = [
    google_compute_shared_vpc_service_project.this,
    time_sleep.wait_for_apis
  ]
}

module "cloudsql_psc" {
  source = "../modules/cloudsql-psc"

  project_id   = google_project.this.project_id
  region       = var.region
  environment  = var.environment
  network_id   = data.terraform_remote_state.bootstrap.outputs.network_hub_np_network_id

  database_version = "POSTGRES_15"
  tier             = "db-f1-micro"
  disk_size        = 10
  availability_type = "ZONAL"
  database_name    = "app_database"

  depends_on = [
    google_compute_shared_vpc_service_project.this,
    time_sleep.wait_for_apis
  ]
}

output "project_id" {
  description = "Dev project ID"
  value       = google_project.this.project_id
}
