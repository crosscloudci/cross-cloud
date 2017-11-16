resource "openstack_compute_instance_v2" "master" {
  count = "${ var.master_node_count }"
  name = "${ var.name }-master-${ count.index + 1 }"
  image_name = "${ var.master_image_name }"
  flavor_name = "${ var.master_flavor_name }"
  security_groups = [ "default" ] # TODO customize security groups
  key_pair = "K8s" # TODO customize keypair
  user_data = "${ element(split("`", var.master_cloud_init), count.index) }"

  network {
    uuid = "${ var.internal_network_id }"
  }
}

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
