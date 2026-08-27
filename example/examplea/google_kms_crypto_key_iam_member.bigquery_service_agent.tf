resource "google_kms_crypto_key_iam_member" "bigquery_service_agent" {
  crypto_key_id = google_kms_crypto_key.bigquery.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.bigquery.email}"
}
