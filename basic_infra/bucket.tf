resource "google_storage_bucket" "img" {
    name = "wp-image-20231201"
    location = var.region
    public_access_prevention = "inherited"
    force_destroy = true
}
