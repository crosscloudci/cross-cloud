# Configure the Microsoft Azure Provider
provider "google" {
  # region      = "${ var.region }"
  project     = "${ var.google_project }"
}

