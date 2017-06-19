resource "google_compute_address" "endpoint" {
  name = "${ var.name }"
  project = "${ var.project }"
  region = "${ var.region }"
}
