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

output "project_id" {
  value = google_project.this.project_id
}
