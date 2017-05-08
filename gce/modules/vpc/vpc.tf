resource "google_compute_network" "cncf" {
  name                = "${ var.name }"
  auto_create_subnetworks = "false"
}


