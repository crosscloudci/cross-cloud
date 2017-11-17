resource "openstack_lb_member_v2" "internal_http" {
  count = "${ var.master_node_count }"
  pool_id = "${ var.internal_lb_http_pool_id }"
  address = "${ element(openstack_compute_instance_v2.master.*.network.0.fixed_ip_v4, count.index) }"
  subnet_id = "${ var.internal_network_subnet_id }"
  protocol_port = 8080
}

resource "openstack_lb_member_v2" "internal_https" {
  count = "${ var.master_node_count }"
  pool_id = "${ var.internal_lb_https_pool_id }"
  address = "${ element(openstack_compute_instance_v2.master.*.network.0.fixed_ip_v4, count.index) }"
  subnet_id = "${ var.internal_network_subnet_id }"
  protocol_port = 443
}
