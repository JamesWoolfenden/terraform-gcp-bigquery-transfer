resource "google_service_account" "transfer" {
  account_id   = "bigquery-transfer"
  display_name = "BigQuery Data Transfer service account"
}
