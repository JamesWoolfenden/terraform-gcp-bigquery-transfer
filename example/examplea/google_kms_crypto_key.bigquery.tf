resource "google_kms_crypto_key" "bigquery" {
  name            = "bigquery-key"
  key_ring        = google_kms_key_ring.bigquery.id
  rotation_period = "2592000s"

  lifecycle {
    prevent_destroy = true
  }
}
