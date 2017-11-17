resource "openstack_lb_loadbalancer_v2" "external_lb" {
  name = "external_lb"
  vip_subnet_id = "${ var.external_lb_subnet_id }"
}

resource "openstack_lb_listener_v2" "external_https" {
  protocol = "HTTPS"
  protocol_port = 443
  loadbalancer_id = "${ openstack_lb_loadbalancer_v2.external_lb.id }"
}

resource "openstack_lb_pool_v2" "external_https" {
  protocol = "HTTPS"
  lb_method = "ROUND_ROBIN"
  listener_id = "${ openstack_lb_listener_v2.external_https.id }"
}
