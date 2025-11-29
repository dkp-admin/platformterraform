resource "random_id" "db_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "main" {
  name             = "${var.environment}-sql-${random_id.db_suffix.hex}"
  project          = var.project_id
  region           = var.region
  database_version = var.database_version

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    disk_size         = var.disk_size
    disk_type         = "PD_SSD"
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = null
      enable_private_path_for_google_cloud_services = true
      psc_config {
        psc_enabled               = true
        allowed_consumer_projects = [var.project_id]
      }
    }

    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      point_in_time_recovery_enabled = true
      backup_retention_settings {
        retained_backups = 7
      }
    }

    maintenance_window {
      day  = 7
      hour = 3
    }

    insights_config {
      query_insights_enabled  = true
      record_application_tags = true
      record_client_address   = false  # PSC does not support record_client_address
    }

    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }

    user_labels = {
      environment = var.environment
      managed_by  = "terraform"
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "main" {
  name     = var.database_name
  project  = var.project_id
  instance = google_sql_database_instance.main.name
}

resource "random_password" "db_password" {
  length  = 24
  special = true
}

resource "google_sql_user" "main" {
  name     = "app_user"
  project  = var.project_id
  instance = google_sql_database_instance.main.name
  password = random_password.db_password.result
}

resource "google_secret_manager_secret" "db_password" {
  secret_id = "${var.environment}-db-password"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

# PSC endpoint address - must be in the host project's network/subnet
resource "google_compute_address" "psc_endpoint" {
  name         = "${var.environment}-sql-psc-endpoint"
  project      = var.host_project_id  # Use host project for Shared VPC
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = "projects/${var.host_project_id}/regions/${var.region}/subnetworks/${var.subnet_name}"
  purpose      = "GCE_ENDPOINT"
}

# PSC forwarding rule - must be in the host project
resource "google_compute_forwarding_rule" "psc_forwarding_rule" {
  name                  = "${var.environment}-sql-psc-forwarding-rule"
  project               = var.host_project_id  # Use host project for Shared VPC
  region                = var.region
  network               = var.network_id
  ip_address            = google_compute_address.psc_endpoint.id
  load_balancing_scheme = ""
  target                = google_sql_database_instance.main.psc_service_attachment_link
}

# Private DNS zone for Cloud SQL PSC
resource "google_dns_managed_zone" "sql_psc" {
  name        = "${var.environment}-sql-psc-zone"
  project     = var.project_id
  dns_name    = "${var.region}.sql.goog."
  description = "Private DNS zone for Cloud SQL PSC"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = var.network_id
    }
  }
}

# DNS record for Cloud SQL PSC - fix the trailing dot issue
resource "google_dns_record_set" "sql_psc" {
  name         = google_sql_database_instance.main.dns_name  # Remove extra dot
  project      = var.project_id
  managed_zone = google_dns_managed_zone.sql_psc.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.psc_endpoint.address]
}
