# resource "google_compute_address" "endpoint" {
#   name = "${ var.name }"
#   region = "${ var.region }"
# }


# resource "google_compute_forwarding_rule" "external" {
#   name       = "external${ var.name }"
#   target     = "${ google_compute_target_pool.cncf.self_link }"
#   ip_address = "${ google_compute_address.endpoint.self_link }"
#   port_range = "443"
#   load_balancing_scheme = "EXTERNAL"
# }
