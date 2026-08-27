variable "connection_id" {
  type        = string
  description = "Identifier of the BigQuery connection"

  validation {
    condition     = can(regex("^[a-zA-Z0-9][-a-zA-Z0-9_]{0,255}$", var.connection_id))
    error_message = "var.connection_id must be a valid connection identifier"
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the data transfer config"

  validation {
    condition     = length(trimspace(var.display_name)) > 0
    error_message = "var.display_name must be a non-empty string"
  }
}

variable "friendly_name" {
  type        = string
  description = "Friendly name of the connection"
  default     = "Managed by Terraform"

  validation {
    condition     = length(trimspace(var.friendly_name)) > 0
    error_message = "var.friendly_name must be a non-empty string"
  }
}

variable "location" {
  type        = string
  description = "Location of the connection and transfer, must match the destination dataset. Required, since a default cannot know where the caller's dataset lives"

  validation {
    condition     = can(regex("^([A-Za-z]{2}|[a-z]+-[a-z]+[0-9]+)$", var.location))
    error_message = "var.location must be a GCP region such as europe-west2, or a multi-region such as EU or US"
  }
}

variable "destination_dataset_id" {
  type        = string
  description = "Dataset the transfer loads into"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_]{1,255}$", var.destination_dataset_id))
    error_message = "var.destination_dataset_id must be letters, digits or underscores"
  }
}

variable "kms_key_name" {
  type        = string
  description = "Resource name of the Cloud KMS key used by the connection and the transfer's destination tables (CMEK)"
  sensitive   = true

  validation {
    condition     = length(trimspace(var.kms_key_name)) > 0
    error_message = "var.kms_key_name must be a non-empty string"
  }
}

variable "service_account" {
  type        = string
  description = "Email of the service account the transfer runs as. Without it the transfer runs as the person who applied it"

  validation {
    condition     = can(regex("^[^@]+@[^@]+$", var.service_account))
    error_message = "var.service_account must be a service account email address"
  }
}

variable "data_path_template" {
  type        = string
  description = "Cloud Storage path the transfer reads, wildcards allowed"

  validation {
    condition     = can(regex("^gs://", var.data_path_template))
    error_message = "var.data_path_template must be a gs:// URI"
  }
}

variable "destination_table_name_template" {
  type        = string
  description = "Name of the table the transfer writes into"

  validation {
    condition     = length(trimspace(var.destination_table_name_template)) > 0
    error_message = "var.destination_table_name_template must be a non-empty string"
  }
}

variable "schedule" {
  type        = string
  description = "Transfer schedule in Data Transfer Service syntax, for example every day 02:00"
  default     = "every day 02:00"

  validation {
    condition     = length(trimspace(var.schedule)) > 0
    error_message = "var.schedule must be a non-empty string"
  }
}

variable "description" {
  type        = string
  description = "Description of the connection"
  default     = "Managed by Terraform"

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "var.description must be a non-empty string"
  }
}
variable "file_format" {
  type        = string
  description = "Format of the source files the transfer reads"
  default     = "CSV"

  validation {
    condition     = contains(["CSV", "JSON", "AVRO", "PARQUET", "ORC"], var.file_format)
    error_message = "var.file_format must be one of CSV, JSON, AVRO, PARQUET or ORC"
  }
}

variable "write_disposition" {
  type        = string
  description = "APPEND adds to the destination table, MIRROR replaces its contents on every run"
  default     = "APPEND"

  validation {
    condition     = contains(["APPEND", "MIRROR"], var.write_disposition)
    error_message = "var.write_disposition must be APPEND or MIRROR"
  }
}

variable "extra_params" {
  type        = map(string)
  description = "Additional Data Transfer Service params merged into the config, for example skip_leading_rows or field_delimiter"
  default     = {}

  validation {
    condition = length(setintersection(keys(var.extra_params), [
      "data_path_template",
      "destination_table_name_template",
      "file_format",
      "write_disposition",
    ])) == 0
    error_message = "var.extra_params must not set data_path_template, destination_table_name_template, file_format or write_disposition, use the dedicated variable for each"
  }
}

variable "enable_failure_email" {
  type        = bool
  description = "Email the transfer config owner when a scheduled run fails"
  default     = true
}

variable "notification_pubsub_topic" {
  type        = string
  description = "Pub/Sub topic notified on transfer run completion, set to null to disable"
  default     = null

  validation {
    condition     = var.notification_pubsub_topic == null || can(regex("^projects/[^/]+/topics/[^/]+$", var.notification_pubsub_topic))
    error_message = "var.notification_pubsub_topic must be a full topic path, projects/<project>/topics/<topic>"
  }
}
