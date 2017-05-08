resource "google_compute_forwarding_rule" "external" {
  name       = "external${ var.name }"
  target     = "${google_compute_target_pool.cncf.self_link}"
  port_range = "443"
  load_balancing_scheme = "EXTERNAL"
}
