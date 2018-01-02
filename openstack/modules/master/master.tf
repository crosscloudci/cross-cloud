resource "openstack_compute_instance_v2" "master" {
  count = "${ var.master_node_count }"
  name = "${ var.name }-master-${ count.index + 1 }"
  image_name = "${ var.master_image_name }"
  flavor_name = "${ var.master_flavor_name }"
  security_groups = [ "${ var.security_group_name }" ]
  key_pair = "${ var.keypair_name }"
  user_data = "${ element(split("`", var.master_cloud_init), count.index) }"

  network {
    uuid = "${ var.internal_network_id }"
  }
}
