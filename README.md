# terraform-gcp-bigquery-transfer

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-bigquery-transfer/workflows/Verify/badge.svg?branch=master)](https://github.com/JamesWoolfenden/terraform-gcp-bigquery-transfer)
[![Latest Release](https://img.shields.io/github/release/terraform-gcp-bigquery-transfer.svg)](https://github.com/JamesWoolfenden/terraform-gcp-bigquery-transfer/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-bigquery-transfer.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-bigquery-transfer/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module for a CMEK-encrypted BigQuery connection and a scheduled Data
Transfer Service load from Cloud Storage. Exercises holden's
google_bigquery_connection and google_bigquery_data_transfer_config policies.

## Usage

Add **module.transfer.tf** to your code:-

```terraform
module "transfer" {
  source                          = "jameswoolfenden/bigquery-transfer/gcp"
  version                         = "0.0.1"
  connection_id                   = "example-connection"
  display_name                    = "Example landing load"
  location                        = "europe-west2"
  destination_dataset_id          = google_bigquery_dataset.landing.dataset_id
  destination_table_name_template = "landing"
  data_path_template              = "gs://example-bigquery-landing/incoming/*.csv"
  service_account                 = google_service_account.transfer.email
  kms_key_name                    = google_kms_crypto_key.bigquery.id
}
```

A cloud resource connection gets its own Google-managed service account, which
the connection_service_account output exposes; that account, not
var.service_account, is what needs access to whatever the connection reads.

var.service_account is required rather than optional: a transfer created
without one runs with the credentials of whoever applied the configuration,
which breaks the moment that person leaves. The caller needs
roles/iam.serviceAccountTokenCreator on it.

The connection, the transfer and the destination dataset all have to be in the
same location.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_bigquery_connection.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_connection) | resource |
| [google_bigquery_data_transfer_config.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_data_transfer_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_connection_id"></a> [connection\_id](#input\_connection\_id) | Identifier of the BigQuery connection | `string` | n/a | yes |
| <a name="input_data_path_template"></a> [data\_path\_template](#input\_data\_path\_template) | Cloud Storage path the transfer reads, wildcards allowed | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the connection | `string` | `"Managed by Terraform"` | no |
| <a name="input_destination_dataset_id"></a> [destination\_dataset\_id](#input\_destination\_dataset\_id) | Dataset the transfer loads into | `string` | n/a | yes |
| <a name="input_destination_table_name_template"></a> [destination\_table\_name\_template](#input\_destination\_table\_name\_template) | Name of the table the transfer writes into | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the data transfer config | `string` | n/a | yes |
| <a name="input_enable_failure_email"></a> [enable\_failure\_email](#input\_enable\_failure\_email) | Email the transfer config owner when a scheduled run fails | `bool` | `true` | no |
| <a name="input_extra_params"></a> [extra\_params](#input\_extra\_params) | Additional Data Transfer Service params merged into the config, for example skip\_leading\_rows or field\_delimiter | `map(string)` | `{}` | no |
| <a name="input_file_format"></a> [file\_format](#input\_file\_format) | Format of the source files the transfer reads | `string` | `"CSV"` | no |
| <a name="input_friendly_name"></a> [friendly\_name](#input\_friendly\_name) | Friendly name of the connection | `string` | `"Managed by Terraform"` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | Resource name of the Cloud KMS key used by the connection and the transfer's destination tables (CMEK) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the connection and transfer, must match the destination dataset. Required, since a default cannot know where the caller's dataset lives | `string` | n/a | yes |
| <a name="input_notification_pubsub_topic"></a> [notification\_pubsub\_topic](#input\_notification\_pubsub\_topic) | Pub/Sub topic notified on transfer run completion, set to null to disable | `string` | `null` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | Transfer schedule in Data Transfer Service syntax, for example every day 02:00 | `string` | `"every day 02:00"` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Email of the service account the transfer runs as. Without it the transfer runs as the person who applied it | `string` | n/a | yes |
| <a name="input_write_disposition"></a> [write\_disposition](#input\_write\_disposition) | APPEND adds to the destination table, MIRROR replaces its contents on every run | `string` | `"APPEND"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_connection_id"></a> [connection\_id](#output\_connection\_id) | ID of the BigQuery connection |
| <a name="output_connection_service_account"></a> [connection\_service\_account](#output\_connection\_service\_account) | Service account BigQuery uses for this connection, grant it access to the external resource |
| <a name="output_transfer_config_id"></a> [transfer\_config\_id](#output\_transfer\_config\_id) | ID of the data transfer config |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-gcp-bigquery-transfer/issues).

## Copyrights

Copyright © 2019-2026 [Jim Woolfenden](https://github.com/JamesWoolfenden)

## License

See [LICENSE](LICENSE) for full details.


<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "bigquery.connections.create",
    "bigquery.connections.delete",
    "bigquery.connections.get",
    "bigquery.connections.update",
    "bigquery.transfers.get",
    "bigquery.transfers.update"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "bigquery.connections.get",
    "bigquery.transfers.get"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->
