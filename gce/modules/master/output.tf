output "master_ips" { value = "${ join(",", google_compute_instance.cncf.*.network_interface.0.address) }" }
output "public_master_ips" { value = "${ join(",", google_compute_instance.cncf.*.network_interface.0.access_config.0.assigned_nat_ip) }" }

