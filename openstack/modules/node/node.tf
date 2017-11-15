resource "openstack_compute_instance_v2" "cncf" {
  count           = "${ var.node_count }"
  name            = "${ var.name }-node-${ count.index + 10 }"
  image_name      = "${ var.node_image_name }"
  flavor_name     = "${ var.node_flavor_name }"
  security_groups = [ "default" ]
  key_pair = "K8s"

  network {
    uuid = "${ var.private_network_id }"
  }
}
