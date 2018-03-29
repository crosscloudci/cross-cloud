# resource "google_compute_forwarding_rule" "cncf" {
#   name       = "${ var.name }"
#   load_balancing_scheme = "INTERNAL"
#   region     = "${ var.region }"
#   ports      = ["8080", "443"]
#   network    = "${ var.network }"
#   subnetwork = "${ var.subnetwork }"
#   ip_address = "${ var.internal_lb_ip }"
#   backend_service     = "${ google_compute_region_backend_service.cncf.self_link }"
# }
