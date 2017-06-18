output "external_lb" { value = "${ google_compute_address.endpoint.address }" }

output "internal_lb" { value = "${ google_compute_forwarding_rule.cncf.ip_address }" }

