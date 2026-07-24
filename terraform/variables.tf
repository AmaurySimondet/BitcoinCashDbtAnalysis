variable "project_id" {
  description = "Globally unique GCP project ID to create (must not already exist)"
  type        = string
}

variable "project_name" {
  description = "Human-readable display name for the GCP project"
  type        = string
  default     = "Bitcoin Cash dbt Analysis"
}

variable "billing_account" {
  description = "Billing account ID (format: XXXXXX-XXXXXX-XXXXXX)"
  type        = string
}

variable "org_id" {
  description = "Organization ID. Optional for personal accounts without an org."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "Folder ID. Optional; mutually exclusive with org_id."
  type        = string
  default     = null
}

variable "region" {
  description = "Default GCP region"
  type        = string
  default     = "europe-west1"
}

variable "bigquery_location" {
  description = "BigQuery dataset location. Must be US to query bigquery-public-data.crypto_bitcoin_cash."
  type        = string
  default     = "US"
}

variable "staging_dataset_id" {
  description = "BigQuery dataset ID for staging tables"
  type        = string
  default     = "staging"
}

variable "mart_dataset_id" {
  description = "BigQuery dataset ID for data mart tables"
  type        = string
  default     = "mart"
}

variable "dbt_service_account_id" {
  description = "Service account ID (local part before @) used by dbt"
  type        = string
  default     = "dbt-runner"
}

variable "dbt_service_account_display_name" {
  description = "Display name for the dbt service account"
  type        = string
  default     = "dbt Runner"
}

variable "create_service_account_key" {
  description = "If true, create a JSON key for the dbt SA (prefer Workload Identity Federation in CI)"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels applied to project resources"
  type        = map(string)
  default = {
    app     = "bitcoin-cash-dbt"
    managed = "terraform"
  }
}
