resource "google_dns_managed_zone" "yukisato_zone" {
  name     = "yukisato-zone"
  dns_name = "yuki-sato.xyz."
}

resource "google_dns_record_set" "default_record" {
  name         = google_dns_managed_zone.yukisato_zone.dns_name
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.yukisato_zone.name
  // lb ip
  rrdatas      = [
    google_compute_forwarding_rule.webservers-loadbalancer.ip_address,
    google_compute_forwarding_rule.https-loadbalancer.ip_address
  ]
  // web server ip
  # rrdatas      = [google_compute_address.static.address]
}
