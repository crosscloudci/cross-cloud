output "master_ips" { value = "${ join(",", openstack_compute_instance_v2.master.*.network.0.fixed_ip_v4) }" }
