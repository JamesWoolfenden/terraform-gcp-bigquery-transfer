resource "google_storage_bucket" "landing" {
  name                        = "example-bigquery-landing-${data.google_project.current.project_id}"
  location                    = local.location
  force_destroy               = false
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  logging {
    log_bucket        = google_storage_bucket.logging.name
    log_object_prefix = "landing/"
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.bigquery.id
  }

  versioning {
    enabled = true
  }

  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  lifecycle_rule {
    condition {
      age = 90
    }

    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      num_newer_versions         = 3
      days_since_noncurrent_time = 30
      with_state                 = "ARCHIVED"
    }

    action {
      type = "Delete"
    }
  }

  depends_on = [
    google_kms_crypto_key_iam_member.gcs_service_agent,
  ]
}
