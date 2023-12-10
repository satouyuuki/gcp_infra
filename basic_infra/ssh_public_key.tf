resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "yuki01377_gmail_com:${file("~/.ssh/gcp-key.pub")}"
  }
}
