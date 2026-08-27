resource "google_storage_bucket_iam_member" "log_delivery" {
  bucket = google_storage_bucket.logging.name
  role   = "roles/storage.objectCreator"
  member = "group:cloud-storage-analytics@google.com"
}
