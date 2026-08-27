resource "google_kms_key_ring" "bigquery" {
  name     = "bigquery-keyring"
  location = local.location
}
