resource "openstack_networking_network_v2" "cncf" {
  name           = "k8s-private"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "cncf" {
  network_id = "${ openstack_networking_network_v2.cncf.id }"
  cidr       = "${ var.private_network_cidr }"
}

resource "openstack_networking_router_v2" "cncf" {
  name             = "router-k8s-private"
  external_gateway = "${ var.public_network }"
}

resource "openstack_networking_router_interface_v2" "cncf" {
  router_id = "${ openstack_networking_router_v2.cncf.id }"
  subnet_id = "${ openstack_networking_subnet_v2.cncf.id }"
}

resource "openstack_lb_loadbalancer_v2" "cncf" {
  name          = "private_lb"
  vip_subnet_id = "${ openstack_networking_subnet_v2.cncf.id }"
  vip_address   = "${ var.private_lb_ip }"
}
