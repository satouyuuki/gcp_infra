resource "google_compute_instance_group" "webservers" {
  name        = "terraform-webservers"
  description = "Terraform test instance group"
  zone = "asia-northeast1-a"
  instances = [
    google_compute_instance.web.self_link,
  ]

  named_port {
    name = "http"
    port = "80"
  }
}

# Global health check
resource "google_compute_health_check" "webservers-health-check" {
  name        = "webservers-health-check"
  description = "Health check via tcp"

  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 3
  unhealthy_threshold = 2

  tcp_health_check {
    port_name          = "http"
  }
}

# Global backend service
resource "google_compute_backend_service" "webservers-backend-service" {

  name                            = "webservers-backend-service"
  timeout_sec                     = 30
  connection_draining_timeout_sec = 10
  load_balancing_scheme = "EXTERNAL"
  protocol = "HTTP"
  port_name = "http"
  health_checks = [google_compute_health_check.webservers-health-check.self_link]

  backend {
    group = google_compute_instance_group.webservers.self_link
    balancing_mode = "UTILIZATION"
  }
}

resource "google_compute_url_map" "default" {

  name            = "website-map"
  default_service = google_compute_backend_service.webservers-backend-service.self_link
}

# Global http proxy
resource "google_compute_target_http_proxy" "default" {

  name    = "website-proxy"
  url_map = google_compute_url_map.default.id
}

# Regional forwarding rule
resource "google_compute_forwarding_rule" "webservers-loadbalancer" {
  name                  = "website-forwarding-rule"
  ip_protocol           = "TCP"
  port_range            = 80
  load_balancing_scheme = "EXTERNAL"
  network_tier          = "STANDARD"
  target                = google_compute_target_http_proxy.default.id
  region                = var.region
}

resource "google_compute_forwarding_rule" "https-loadbalancer" {
  name                  = "https-forwarding-rule"
  ip_protocol           = "TCP"
  port_range            = 443
  load_balancing_scheme = "EXTERNAL"
  network_tier          = "STANDARD"
  // for ssl 
  target                = google_compute_target_https_proxy.default.id
  region                = var.region
}

resource "google_compute_firewall" "load_balancer_inbound" {
  name    = "nginx-load-balancer"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction = "INGRESS"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags = ["nginx-instance"]
}

// for ssl alb
resource "google_compute_ssl_certificate" "default" {
  name_prefix = "my-certificate-"
  private_key = acme_certificate.certificate.private_key_pem
  certificate = acme_certificate.certificate.certificate_pem

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_target_https_proxy" "default" {
  name             = "test-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_ssl_certificate.default.id]
}
