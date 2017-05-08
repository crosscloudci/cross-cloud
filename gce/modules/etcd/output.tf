output "external_lb" { value = "${ google_compute_forwarding_rule.external.ip_address }" }

output "internal_lb" { value = "${ google_compute_forwarding_rule.cncf.ip_address }" }

