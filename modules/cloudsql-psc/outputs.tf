output "instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.main.name
}

output "instance_connection_name" {
  description = "Cloud SQL instance connection name"
  value       = google_sql_database_instance.main.connection_name
}

output "database_name" {
  description = "Database name"
  value       = google_sql_database.main.name
}

output "psc_endpoint_ip" {
  description = "PSC endpoint IP address"
  value       = google_compute_address.psc_endpoint.address
}

output "dns_name" {
  description = "DNS name for the Cloud SQL instance"
  value       = google_sql_database_instance.main.dns_name
}

output "db_password_secret_id" {
  description = "Secret Manager secret ID for database password"
  value       = google_secret_manager_secret.db_password.secret_id
}
