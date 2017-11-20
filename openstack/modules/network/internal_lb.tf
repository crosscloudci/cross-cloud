resource "openstack_lb_loadbalancer_v2" "internal_lb" {
  name = "internal_lb"
  vip_subnet_id = "${ openstack_networking_subnet_v2.cncf.id }"
  vip_address = "${ var.internal_lb_ip }"
  security_group_ids = [ "${ openstack_networking_secgroup_v2.cncf.id }" ]
}

resource "openstack_lb_listener_v2" "internal_https" {
  protocol = "HTTPS"
  protocol_port = 443
  loadbalancer_id = "${ openstack_lb_loadbalancer_v2.internal_lb.id }"
}

resource "openstack_lb_pool_v2" "internal_https" {
  protocol = "HTTPS"
  lb_method = "ROUND_ROBIN"
  listener_id = "${ openstack_lb_listener_v2.internal_https.id }"
}

resource "openstack_networking_floatingip_v2" "lb_fip" {
  pool = "${ var.floating_ip_pool }"
  port_id = "${ openstack_lb_loadbalancer_v2.internal_lb.vip_port_id }"
}

