resource "openstack_lb_loadbalancer_v2" "internal_lb" {
  name = "internal_lb"
  vip_subnet_id = "${ openstack_networking_subnet_v2.cncf.id }"
  vip_address = "${ var.internal_lb_ip }"
}

resource "openstack_lb_listener_v2" "internal_http" {
  protocol = "HTTP"
  protocol_port = 8080
  loadbalancer_id = "${ openstack_lb_loadbalancer_v2.internal_lb.id }"
}

resource "openstack_lb_listener_v2" "internal_https" {
  protocol = "HTTPS"
  protocol_port = 443
  loadbalancer_id = "${ openstack_lb_loadbalancer_v2.internal_lb.id }"
}

resource "openstack_lb_pool_v2" "internal_http" {
  protocol = "HTTP"
  lb_method = "ROUND_ROBIN"
  listener_id = "${ openstack_lb_listener_v2.internal_http.id }"
}

resource "openstack_lb_pool_v2" "internal_https" {
  protocol = "HTTPS"
  lb_method = "ROUND_ROBIN"
  listener_id = "${ openstack_lb_listener_v2.internal_https.id }"
}
