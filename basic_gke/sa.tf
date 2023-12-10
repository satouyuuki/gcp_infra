resource "google_service_account" "sql-proxy" {
  account_id = "cloudsql-proxy"
  display_name = "cloudsql-proxy"
}


resource "google_project_iam_member" "role" {
  role = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.sql-proxy.email}"
  project = var.accounts.project
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.sql-proxy.name
}

resource "local_file" "key" {
  filename = "key.json"
  content = base64decode(google_service_account_key.key.private_key)
}
