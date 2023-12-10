terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
	acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
  }
}

provider "google" {}

provider "acme" {
      server_url = "https://acme-v02.api.letsencrypt.org/directory"
      # server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}
