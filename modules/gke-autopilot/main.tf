resource "google_container_cluster" "autopilot" {
  name     = "${var.environment}-gke-autopilot"
  project  = var.project_id
  location = var.region

  enable_autopilot = true

  # For Shared VPC, use full resource paths
  network    = "projects/${var.host_project_id}/global/networks/${var.network_name}"
  subnetwork = "projects/${var.host_project_id}/regions/${var.region}/subnetworks/${var.subnet_name}"

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  maintenance_policy {
    recurring_window {
      start_time = "2024-01-01T09:00:00Z"
      end_time   = "2024-01-01T17:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  deletion_protection = false

  resource_labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
