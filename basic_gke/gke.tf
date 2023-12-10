resource "google_container_cluster" "cluster" {
  name = "persistent-disk-tutorial"
  location = var.accounts.region
  remove_default_node_pool = true
  initial_node_count = 1
  network = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.sub.id
  ip_allocation_policy {
    cluster_secondary_range_name = google_compute_subnetwork.sub.secondary_ip_range.1.range_name
    services_secondary_range_name = google_compute_subnetwork.sub.secondary_ip_range.0.range_name
  }
  deletion_protection = false
}

resource "google_container_node_pool" "node" {
  name = "node-pool"
  location = var.accounts.region
  cluster = google_container_cluster.cluster.name
  node_count = 1
  node_config {
    preemptible = true
    machine_type = "e2-micro"
    service_account = google_service_account.sql-proxy.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
