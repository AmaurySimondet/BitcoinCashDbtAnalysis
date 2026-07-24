resource "google_service_account" "dbt_runner" {
  project      = google_project.bch_analysis.project_id
  account_id   = var.dbt_service_account_id
  display_name = var.dbt_service_account_display_name
  description  = "Service account used by dbt / CI to run BigQuery transformations"

  depends_on = [google_project_service.required_apis]
}

# Run queries and create temporary result tables / jobs
resource "google_project_iam_member" "dbt_job_user" {
  project = google_project.bch_analysis.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dbt_runner.email}"
}

# Read project metadata / list datasets (useful for dbt docs & discovery)
resource "google_project_iam_member" "dbt_data_viewer" {
  project = google_project.bch_analysis.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${google_service_account.dbt_runner.email}"
}

# Create scratch datasets (e.g. dbt_ci profile dataset in GitHub Actions)
resource "google_project_iam_member" "dbt_user" {
  project = google_project.bch_analysis.project_id
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${google_service_account.dbt_runner.email}"
}

# Full read/write on staging dataset (create/replace staging models)
resource "google_bigquery_dataset_iam_member" "dbt_staging_editor" {
  project    = google_project.bch_analysis.project_id
  dataset_id = google_bigquery_dataset.staging.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt_runner.email}"
}

# Full read/write on mart dataset (create/replace mart models)
resource "google_bigquery_dataset_iam_member" "dbt_mart_editor" {
  project    = google_project.bch_analysis.project_id
  dataset_id = google_bigquery_dataset.mart.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt_runner.email}"
}

# Optional key for local/CI use. Prefer Workload Identity Federation in production.
resource "google_service_account_key" "dbt_runner" {
  count = var.create_service_account_key ? 1 : 0

  service_account_id = google_service_account.dbt_runner.name
}
