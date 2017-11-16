resource "openstack_compute_instance_v2" "cncf" {
  count           = "${ var.master_count }"
  name            = "${ var.name }-master-${ count.index + 10 }"
  image_name      = "${ var.master_image_name }"
  flavor_name     = "${ var.master_flavor_name }"
  security_groups = [ "default" ]
  key_pair        = "K8s"
  user_data       = "${ element(split("`", var.master_cloud_init), count.index) }"

  network {
    uuid = "${ var.private_network_id }"
  }
}
