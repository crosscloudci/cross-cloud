resource "openstack_networking_network_v2" "cncf" {
  name           = "k8s-private"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "cncf" {
  network_id = "${openstack_networking_network_v2.cncf.id}"
  cidr       = "192.168.11.0/24"
}
