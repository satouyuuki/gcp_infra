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

data "google_client_config" "provider" {}

provider "kubernetes" {
  host = "https://${google_container_cluster.cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
  )
}
