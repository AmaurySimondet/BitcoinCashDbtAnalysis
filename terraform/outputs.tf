output "project_id" {
  description = "Created GCP project ID"
  value       = google_project.bch_analysis.project_id
}

output "project_number" {
  description = "Created GCP project number"
  value       = google_project.bch_analysis.number
}

output "staging_dataset_id" {
  description = "BigQuery staging dataset ID"
  value       = google_bigquery_dataset.staging.dataset_id
}

output "mart_dataset_id" {
  description = "BigQuery data mart dataset ID"
  value       = google_bigquery_dataset.mart.dataset_id
}

output "bigquery_location" {
  description = "BigQuery location for both datasets"
  value       = var.bigquery_location
}

output "dbt_service_account_email" {
  description = "Email of the dbt service account"
  value       = google_service_account.dbt_runner.email
}

output "dbt_service_account_key" {
  description = "Base64-encoded private key JSON for the dbt service account (sensitive; null if not created)"
  value       = var.create_service_account_key ? google_service_account_key.dbt_runner[0].private_key : null
  sensitive   = true
}
