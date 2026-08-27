# holden:ignore:HLD_GCP_003 — terminal access-log destination, a bucket cannot log to
# itself (HLD_GCP_451) and a second log bucket would only move the problem one hop.
resource "google_storage_bucket" "logging" {
  name                        = "example-bigquery-landing-logs-${data.google_project.current.project_id}"
  location                    = local.location
  force_destroy               = false
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

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
