provider "google" {
  # Authenticate via Application Default Credentials or GOOGLE_APPLICATION_CREDENTIALS.
  # Creating a project requires billing permissions on the calling identity.
  region = var.region
}
