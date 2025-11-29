variable "project_id" {
  description = "GCP Project ID (service project)"
  type        = string
}

variable "host_project_id" {
  description = "Shared VPC host project ID"
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

variable "network_name" {
  description = "VPC network name (in host project)"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name (in host project)"
  type        = string
}

variable "pods_range_name" {
  description = "Name of the secondary range for pods"
  type        = string
}

variable "services_range_name" {
  description = "Name of the secondary range for services"
  type        = string
}

variable "master_authorized_networks" {
  description = "List of master authorized networks"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for the cluster"
  type        = bool
  default     = false
}
