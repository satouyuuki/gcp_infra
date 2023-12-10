resource "google_compute_address" "static" {
  name = "ipv4-address"
}

resource "google_compute_instance" "web" {
  name         = "web-vm"
  machine_type = "e2-micro"
  zone         = "asia-northeast1-a"
  tags         = ["ssh", "web", "nginx-instance"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.pub_subnet.id

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}
