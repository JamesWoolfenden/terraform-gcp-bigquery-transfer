resource "google_kms_crypto_key_iam_member" "bigquery_service_agent" {
  crypto_key_id = google_kms_crypto_key.bigquery.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_bigquery_default_service_account.bigquery.email}"
}
