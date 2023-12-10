resource "google_compute_network" "vpc" {
  name = "gke-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub" {
  name = "gke-subnet"
  ip_cidr_range = "10.1.0.0/16"
  region = var.accounts.region
  network = google_compute_network.vpc.id
  secondary_ip_range {
    range_name = "service-range"
    ip_cidr_range = "192.168.1.0/24"
  }
  
  secondary_ip_range {
    range_name = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}
