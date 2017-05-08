resource "google_compute_subnetwork" "cncf" {
  name          = "${ var.name }"
  ip_cidr_range = "${ var.cidr }"
  network       = "${ google_compute_network.cncf.self_link }"
  region        = "${ var.region }"
}
