resource "google_project_service_identity" "bigquery" {
  provider = google-beta
  service  = "bigquery.googleapis.com"
}
