resource "google_compute_network" "vpc_network" {
  name                            = "infra-base"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "pub_subnet" {
  name          = "pub-sub"
  ip_cidr_range = "10.0.10.0/24"
  region        = "asia-northeast1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "pri_subnet" {
  name          = "pri-sub"
  ip_cidr_range = "10.0.20.0/24"
  region        = "asia-northeast1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "pri_subnet_2nd" {
  name          = "pri-sub-2nd"
  ip_cidr_range = "10.0.21.0/24"
  region        = "asia-northeast1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_route" "route" {
  name             = "default-route"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "web" {
  name = "allow-web"
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

resource "google_compute_firewall" "db" {
  name = "allow-db"
  allow {
    ports    = ["3306"]
    protocol = "tcp"
  }
  network     = google_compute_network.vpc_network.id
  source_tags = ["web"]
  target_tags = ["db"]
}
