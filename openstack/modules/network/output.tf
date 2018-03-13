output "network_id" { value = "${ openstack_networking_network_v2.k8s.id }" }
output "subnet_id" { value = "${ openstack_networking_subnet_v2.k8s.id }" }
output "security_group_id" { value = "${ openstack_networking_secgroup_v2.k8s.id }" }
output "security_group_name" { value = "${ openstack_networking_secgroup_v2.k8s.name }" }
output "fip" { value = "${ openstack_compute_floatingip_v2.fip.address }" }
output "lb_port" { value = "${ openstack_networking_port_v2.lb_port.id }" }
output "lb_ip" { value = "${ openstack_networking_port_v2.lb_port.all_fixed_ips.0 }" }
