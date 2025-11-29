variable "org_id" {
  type = string
}

variable "folder_name" {
  description = "Parent folder resource name (folders/XXXXX or folders/NNNN/folders/MMMM)"
  type        = string
}

variable "billing_account" {
  type = string
}

variable "region" {
  description = "GCP region for network-hub-np"
  type        = string
}

variable "environment" {
  description = "Environment label (e.g. np)"
  type        = string
}

variable "project_id" {
  type = string
}

variable "project_name" {
  type = string
}
