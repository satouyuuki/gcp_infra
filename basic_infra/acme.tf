resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "yuki01377@gmail.com"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "yuki-sato.xyz"

  dns_challenge {
    provider = "gcloud"
    config = {
        GCE_PROJECT = var.project
    }
  }
}
