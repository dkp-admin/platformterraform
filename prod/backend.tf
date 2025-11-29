terraform {
  backend "gcs" {
    bucket = "bootstrap-tijarah-terraform-state"
    prefix = "terraform/state/prod"
  }
}
