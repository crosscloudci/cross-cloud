### Internal Network
resource "openstack_networking_network_v2" "k8s" {
  name           = "k8s-internal"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "k8s" {
  name = "k8s-subnet"
  network_id = "${ openstack_networking_network_v2.k8s.id }"
  cidr = "${ var.internal_network_cidr }"
  dns_nameservers  = [ "8.8.8.8" ]
}

resource "openstack_networking_router_v2" "k8s" {
  name = "k8s-router"
  external_gateway = "${ var.external_network_id }"
}

resource "openstack_networking_router_interface_v2" "ks" {
  router_id = "${ openstack_networking_router_v2.k8s.id }"
  subnet_id = "${ openstack_networking_subnet_v2.k8s.id }"
}

#### Security Groups

resource "openstack_networking_secgroup_v2" "k8s" {
  name        = "k8s-secgroup"
  description = "Cross Cloud Security Group (ssh, http, https)"
}

resource "openstack_networking_secgroup_rule_v2" "k8s_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${ openstack_networking_secgroup_v2.k8s.id }"
}

resource "openstack_networking_secgroup_rule_v2" "k8s_etcd" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "2379" 
  port_range_max    = "2381"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${ openstack_networking_secgroup_v2.k8s.id }"
}

resource "openstack_networking_secgroup_rule_v2" "k8s_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${ openstack_networking_secgroup_v2.k8s.id }"
}

### Floating IP

resource "openstack_compute_floatingip_v2" "fip" {
  pool = "${ var.floating_ip_pool }"
}

resource "openstack_networking_port_v2" "lb_port" {
  name = "lb_ip"
  network_id = "${ openstack_networking_network_v2.k8s.id }"
  admin_state_up = "true"
  security_group_ids = [ "${ openstack_networking_secgroup_v2.k8s.id }" ]
  fixed_ip {
    subnet_id = "${ openstack_networking_subnet_v2.k8s.id }"
  }
}
