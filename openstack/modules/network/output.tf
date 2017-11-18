output "internal_network_id" { value = "${ openstack_networking_network_v2.cncf.id }" }
output "internal_network_subnet_id" { value = "${ openstack_networking_subnet_v2.cncf.id }" }
output "internal_lb_http_pool_id" { value = "${ openstack_lb_pool_v2.internal_http.id }" }
output "internal_lb_https_pool_id" { value = "${ openstack_lb_pool_v2.internal_https.id }" }
output "cross_cloud_security_group_id" { value = "${ openstack_networking_secgroup_v2.cncf.id }" }
output "cross_cloud_security_group_name" { value = "${ openstack_networking_secgroup_v2.cncf.name }" }
