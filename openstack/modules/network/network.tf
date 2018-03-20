### Internal Network
resource "openstack_networking_network_v2" "k8s" {
  name           = "${ var.name }-internal"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "k8s" {
  name = "${ var.name }-subnet"
  network_id = "${ openstack_networking_network_v2.k8s.id }"
  cidr = "${ var.internal_network_cidr }"
  dns_nameservers  = [ "8.8.8.8" ]
}

resource "openstack_networking_router_v2" "k8s" {
  name = "${ var.name }-router"
  external_network_id = "${ var.external_network_id }"
}

resource "openstack_networking_router_interface_v2" "ks" {
  router_id = "${ openstack_networking_router_v2.k8s.id }"
  subnet_id = "${ openstack_networking_subnet_v2.k8s.id }"
}

#### Security Groups

resource "openstack_networking_secgroup_v2" "k8s" {
  name        = "${ var.name }-secgroup"
  description = "Cross Cloud Security Group (ssh, http, https, kubernetes, icmp)"
}

resource "openstack_networking_secgroup_rule_v2" "kubernetes_tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${ openstack_networking_secgroup_v2.k8s.id }"
}

resource "openstack_networking_secgroup_rule_v2" "kubernetes_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${ openstack_networking_secgroup_v2.k8s.id }"
}

resource "openstack_networking_secgroup_rule_v2" "kubernetes_icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${ openstack_networking_secgroup_v2.k8s.id }"
}


### Floating IPs

resource "openstack_compute_floatingip_v2" "master" {
  count = "${ var.count }"
  pool = "${ var.floating_ip_pool }"
}

# resource "openstack_compute_floatingip_v2" "fip" {
#   pool = "${ var.floating_ip_pool }"
# }

# resource "openstack_networking_port_v2" "lb_port" {
#   name = "${ var.name }_lb_ip"
#   network_id = "${ openstack_networking_network_v2.k8s.id }"
#   admin_state_up = "true"
#   security_group_ids = [ "${ openstack_networking_secgroup_v2.k8s.id }" ]
#   fixed_ip {
#     subnet_id = "${ openstack_networking_subnet_v2.k8s.id }"
#   }
# }
