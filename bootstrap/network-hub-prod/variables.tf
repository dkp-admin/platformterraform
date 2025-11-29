variable "org_id" { type = string }
variable "folder_name" { type = string }
variable "billing_account" { type = string }

variable "region" {
  description = "GCP region for network-hub-prod"
  type        = string
}

variable "environment" {
  description = "Environment label (e.g. prod)"
  type        = string
}

variable "project_id" { type = string }
variable "project_name" { type = string }
