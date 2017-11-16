resource "openstack_networking_network_v2" "cncf" {
  name           = "k8s-internal"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "cncf" {
  network_id = "${ openstack_networking_network_v2.cncf.id }"
  cidr = "${ var.internal_network_cidr }"
  dns_nameservers  = [ "8.8.8.8" ]
}

resource "openstack_networking_router_v2" "cncf" {
  name = "router-k8s-internal"
  external_gateway = "${ var.external_network_id }"
}

resource "openstack_networking_router_interface_v2" "cncf" {
  router_id = "${ openstack_networking_router_v2.cncf.id }"
  subnet_id = "${ openstack_networking_subnet_v2.cncf.id }"
}

