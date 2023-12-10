terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
 backend "gcs" {
   bucket = "gke-basic-tfstate-ee50831bef55c390"
   prefix = "terraform/state"
 }
}

provider "google" {
  project = var.accounts.project
  region = var.accounts.region
  zone = var.accounts.zone
}
