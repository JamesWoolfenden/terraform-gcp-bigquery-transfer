output "connection_id" {
  value       = google_bigquery_connection.main.id
  description = "ID of the BigQuery connection"
}

output "connection_service_account" {
  value       = try(google_bigquery_connection.main.cloud_resource[0].service_account_id, null)
  description = "Service account BigQuery uses for this connection, grant it access to the external resource"
}

output "transfer_config_id" {
  value       = google_bigquery_data_transfer_config.main.id
  description = "ID of the data transfer config"
}
