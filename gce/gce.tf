# Configure the Google Provider
provider "google" {
  # region      = "${ var.region }"
  project     = "${ var.google_project }"
}

