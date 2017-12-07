resource "openstack_networking_secgroup_v2" "cncf" {
  name        = "cncf"
  description = "Cross Cloud Security Group (ssh, http, https)"
}

resource "openstack_networking_secgroup_rule_v2" "cncf_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${ openstack_networking_secgroup_v2.cncf.id }"
}

resource "openstack_networking_secgroup_rule_v2" "cncf_etcd" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "2379" 
  port_range_max    = "2381"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${ openstack_networking_secgroup_v2.cncf.id }"
}

resource "openstack_networking_secgroup_rule_v2" "cncf_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${ openstack_networking_secgroup_v2.cncf.id }"
}
