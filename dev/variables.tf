variable "org_id" {
  description = "Organization ID"
  type        = string
}

variable "env_folder_id" {
  description = "GCP folder ID for env-tijarah/dev"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
}

variable "region" {
  description = "GCP region for dev"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_id" {
  description = "Dev project ID"
  type        = string
  default     = "dev-tijarah"
}

variable "project_name" {
  description = "Dev project display name"
  type        = string
  default     = "Dev Tijarah"
}
