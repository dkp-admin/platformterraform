variable "org_id" {
  description = "Organization ID"
  type        = string
}

variable "env_folder_id" {
  description = "GCP folder ID for env-tijarah/prod"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
}

variable "region" {
  description = "GCP region for prod"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "project_id" {
  description = "Prod project ID"
  type        = string
  default     = "prod-tijarah"
}

variable "project_name" {
  description = "Prod project display name"
  type        = string
  default     = "Prod Tijarah"
}
