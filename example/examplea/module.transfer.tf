# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
# holden:ignore:HLD_TF_065: for expansion
module "transfer" {
  source                          = "../../"
  connection_id                   = "example-connection"
  display_name                    = "Example landing load"
  location                        = local.location
  destination_dataset_id          = google_bigquery_dataset.landing.dataset_id
  destination_table_name_template = "landing"
  data_path_template              = "gs://${google_storage_bucket.landing.name}/incoming/*.csv"
  service_account                 = google_service_account.transfer.email
  kms_key_name                    = google_kms_crypto_key.bigquery.id

  depends_on = [google_kms_crypto_key_iam_member.bigquery_service_agent]
}
