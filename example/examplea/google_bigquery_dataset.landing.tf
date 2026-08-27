resource "google_bigquery_dataset" "landing" {
  dataset_id                      = "example_landing"
  location                        = local.location
  description                     = "Landing dataset for the example transfer"
  delete_contents_on_destroy      = false
  default_table_expiration_ms     = 7776000000
  default_partition_expiration_ms = 7776000000

  default_encryption_configuration {
    kms_key_name = google_kms_crypto_key.bigquery.id
  }
}
