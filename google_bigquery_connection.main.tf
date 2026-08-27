resource "google_bigquery_connection" "main" {
  connection_id = var.connection_id
  location      = var.location
  friendly_name = var.friendly_name
  description   = var.description
  kms_key_name  = var.kms_key_name

  cloud_resource {}
}
