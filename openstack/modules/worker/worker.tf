resource "openstack_compute_instance_v2" "cncf" {
  count = "${ var.worker_node_count }"
  name = "${ var.name }-worker-${ count.index + 10 }"
  image_name = "${ var.worker_image_name }"
  flavor_name = "${ var.worker_flavor_name }"
  security_groups = [ "default" ]
  key_pair = "K8s"

  network {
    uuid = "${ var.internal_network_id }"
  }
}
