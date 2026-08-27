resource "google_bigquery_data_transfer_config" "main" {
  display_name              = var.display_name
  location                  = var.location
  data_source_id            = "google_cloud_storage"
  destination_dataset_id    = var.destination_dataset_id
  schedule                  = var.schedule
  service_account_name      = var.service_account
  notification_pubsub_topic = var.notification_pubsub_topic

  params = merge({
    data_path_template              = var.data_path_template
    destination_table_name_template = var.destination_table_name_template
    file_format                     = var.file_format
    write_disposition               = var.write_disposition
  }, var.extra_params)

  email_preferences {
    enable_failure_email = var.enable_failure_email
  }

  encryption_configuration {
    kms_key_name = var.kms_key_name
  }
}
