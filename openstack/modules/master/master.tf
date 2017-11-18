resource "openstack_compute_instance_v2" "master" {
  count = "${ var.master_node_count }"
  name = "${ var.name }-master-${ count.index + 1 }"
  image_name = "${ var.master_image_name }"
  flavor_name = "${ var.master_flavor_name }"
  security_groups = [ "default", "${ var.security_group_name }" ] # TODO customize security groups
  key_pair = "K8s" # TODO customize keypair
  user_data = "${ element(split("`", var.master_cloud_init), count.index) }"

  network {
    uuid = "${ var.internal_network_id }"
  }
}
