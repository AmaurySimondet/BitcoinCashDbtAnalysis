locals {
  # org_id and folder_id are mutually exclusive on google_project.
  parent_org_id    = var.folder_id == null ? var.org_id : null
  parent_folder_id = var.folder_id
}

resource "google_project" "bch_analysis" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account
  org_id          = local.parent_org_id
  folder_id       = local.parent_folder_id
  labels          = var.labels

  # Personal / free-trial accounts often have no org — omit both parents.
  # Prevent accidental deletion of a billed project from local state mistakes.
  deletion_policy = "PREVENT"
}

# APIs required for BigQuery + IAM used by dbt
resource "google_project_service" "required_apis" {
  for_each = toset([
    "bigquery.googleapis.com",
    "bigquerystorage.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
  ])

  project            = google_project.bch_analysis.project_id
  service            = each.value
  disable_on_destroy = false
}
