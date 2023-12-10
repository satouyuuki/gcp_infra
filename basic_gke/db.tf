resource "random_password" "pass" {
  length = 16
  special = true
}

resource "google_sql_database_instance" "sql" {
  name = "mysql-wordpress-instance"
  database_version = "MYSQL_8_0"
  region = var.accounts.region
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = "false"
}

resource "google_sql_user" "user" {
  name = "wordpress"
  instance = google_sql_database_instance.sql.name
  host = "%"
  password = random_password.pass.result
}

resource "google_sql_database" "database" {
  name = "wordpress"
  instance = google_sql_database_instance.sql.name
}
