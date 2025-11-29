# Bootstrap: creates platform/env folders and platform projects

locals {
  platform_folder_display_name = "platform-tijarah"
  env_folder_display_name      = "env-tijarah"
}

# Parent Tijarah folder (already exists, id. provided via tfvars)

resource "google_folder" "platform" {
  display_name = local.platform_folder_display_name
  parent       = "folders/${var.folder_id}"
}

resource "google_folder" "env" {
  display_name = local.env_folder_display_name
  parent       = "folders/${var.folder_id}"
}

resource "google_folder" "env_dev" {
  display_name = "dev"
  parent       = google_folder.env.name
}

resource "google_folder" "env_prod" {
  display_name = "prod"
  parent       = google_folder.env.name
}

 # Platform projects under platform-tijarah folder

 module "network_hub_np" {
   source = "./network-hub-np"

   org_id         = var.org_id
   folder_name    = google_folder.platform.name
   billing_account = var.billing_account
   region         = "us-central1"
   environment    = "np"
   project_id     = "network-hub-np-prj"
   project_name   = "network-hub-np-prj"
 }

# module "network_spoke_np" {
#   source = "./network-spoke-np"
#
#   org_id         = var.org_id
#   folder_name    = google_folder.platform.name
#   billing_account = var.billing_account
#   project_id     = "network-spoke-np-prj"
#   project_name   = "network-spoke-np-prj"
# }

 # The following platform projects are temporarily disabled due to project quota limits:
 # module "network_hub_prod" {
 #   source = "./network-hub-prod"
 #
 #   org_id         = var.org_id
 #   folder_name    = google_folder.platform.name
 #   billing_account = var.billing_account
 #   region         = "us-central1"
 #   environment    = "prod"
 #   project_id     = "network-hub-prod"
 #   project_name   = "Network Hub Prod"
 # }
 #
 # module "network_spoke_prod" {
 #   source = "./network-spoke-prod"
 #
 #   org_id         = var.org_id
 #   folder_name    = google_folder.platform.name
 #   billing_account = var.billing_account
 #   project_id     = "network-spoke-prod"
 #   project_name   = "Network Spoke Prod"
 # }
 #
 # module "security" {
 #   source = "./security-tijarah"
 #
 #   org_id         = var.org_id
 #   folder_name    = google_folder.platform.name
 #   billing_account = var.billing_account
 #   project_id     = "security-tijarah"
 #   project_name   = "Security Tijarah"
 # }
 #
 # module "logging" {
 #   source = "./logging-tijarah"
 #
 #   org_id         = var.org_id
 #   folder_name    = google_folder.platform.name
 #   billing_account = var.billing_account
 #   project_id     = "logging-tijarah"
 #   project_name   = "Logging Tijarah"
 # }
 #
 # module "monitoring" {
 #   source = "./monitoring-tijarah"
 #
 #   org_id         = var.org_id
 #   folder_name    = google_folder.platform.name
 #   billing_account = var.billing_account
 #   project_id     = "monitoring-tijarah"
 #   project_name   = "Monitoring Tijarah"
 # }

output "platform_folder_name" {
  value = google_folder.platform.name
}

output "env_dev_folder_name" {
  value = google_folder.env_dev.name
}

output "env_prod_folder_name" {
  value = google_folder.env_prod.name
}

output "network_hub_np_network_name" {
  value = module.network_hub_np.network_name
}

output "network_hub_np_subnet_name" {
  value = module.network_hub_np.subnet_name
}

output "network_hub_np_pods_range_name" {
  value = module.network_hub_np.pods_range_name
}

output "network_hub_np_services_range_name" {
  value = module.network_hub_np.services_range_name
}

output "network_hub_np_project_id" {
  value = module.network_hub_np.project_id
}

output "network_hub_np_network_id" {
  value = module.network_hub_np.network_id
}

 # Outputs for PROD hub are commented out until network_hub_prod is re-enabled
 # output "network_hub_prod_network_name" {
 #   value = module.network_hub_prod.network_name
 # }
 #
 # output "network_hub_prod_subnet_name" {
 #   value = module.network_hub_prod.subnet_name
 # }
 #
 # output "network_hub_prod_pods_range_name" {
 #   value = module.network_hub_prod.pods_range_name
 # }
 #
 # output "network_hub_prod_services_range_name" {
 #   value = module.network_hub_prod.services_range_name
 # }
 #
 # output "network_hub_prod_project_id" {
 #   value = module.network_hub_prod.project_id
 # }
 #
 # output "network_hub_prod_network_id" {
 #   value = module.network_hub_prod.network_id
 # }
