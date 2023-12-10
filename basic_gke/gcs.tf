resource "random_id" "prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "tfstate" {
  name = "gke-basic-tfstate-${random_id.prefix.hex}"
  location = var.accounts.region
  force_destroy = true
}
