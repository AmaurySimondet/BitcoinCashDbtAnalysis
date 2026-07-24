resource "google_bigquery_dataset" "staging" {
  project                     = google_project.bch_analysis.project_id
  dataset_id                  = var.staging_dataset_id
  friendly_name               = "Staging"
  description                 = "Staging tables for Bitcoin Cash dbt models (cleaned / intermediate)"
  location                    = var.bigquery_location
  delete_contents_on_destroy  = false
  default_table_expiration_ms = null

  labels = merge(var.labels, {
    layer = "staging"
  })

  depends_on = [google_project_service.required_apis]
}

resource "google_bigquery_dataset" "mart" {
  project                     = google_project.bch_analysis.project_id
  dataset_id                  = var.mart_dataset_id
  friendly_name               = "Data Mart"
  description                 = "Data mart tables for Bitcoin Cash analytics (dbt marts)"
  location                    = var.bigquery_location
  delete_contents_on_destroy  = false
  default_table_expiration_ms = null

  labels = merge(var.labels, {
    layer = "mart"
  })

  depends_on = [google_project_service.required_apis]
}
