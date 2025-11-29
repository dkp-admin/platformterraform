variable "org_id" {
  description = "Organization ID"
  type        = string
}

variable "folder_id" {
  description = "Folder ID for Tijarah"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
}

variable "bootstrap_project_id" {
  description = "Bootstrap project ID"
  type        = string
  default     = "bootstrap-tijarah"
}
