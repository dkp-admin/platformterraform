variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "network_id" {
  description = "VPC network ID"
  type        = string
}

variable "database_version" {
  description = "Database version"
  type        = string
  default     = "POSTGRES_15"
}

variable "tier" {
  description = "Machine tier for Cloud SQL"
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 10
}

variable "availability_type" {
  description = "Availability type (REGIONAL or ZONAL)"
  type        = string
  default     = "ZONAL"
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
  default     = "app_database"
}
