resource "google_sql_database_instance" "instance" {
  name             = "mysql-instance"
  region           = "asia-northeast1"
  database_version = "MYSQL_8_0"
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
  settings {
      tier = "db-f1-micro"
      ip_configuration {
          dynamic "authorized_networks" {
              for_each = google_compute_instance.web
              iterator = web

              content {
                  name = "web-access"
                  value = google_compute_address.static.address
              }
          }
      }
  }
}

resource "random_password" "pwd" {
  length  = 16
  special = false
}

resource "google_sql_user" "user" {
  name     = "user"
  instance = google_sql_database_instance.instance.name
  password = random_password.pwd.result
}

output "connection_name" {
  value = google_sql_database_instance.instance.connection_name
}
