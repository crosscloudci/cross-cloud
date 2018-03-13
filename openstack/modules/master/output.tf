output "ips" { value = "${ openstack_compute_instance_v2.master.*.network.0.fixed_ip_v4 }" }
