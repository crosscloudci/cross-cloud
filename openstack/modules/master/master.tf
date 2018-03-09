resource "openstack_compute_instance_v2" "master" {
  count           = "${ var.count }"
  name            = "${ var.name }-master-${ count.index + 1 }"
  image_name      = "${ var.image }"
  flavor_name     = "${ var.flavor }"
  security_groups = [ "${ var.security_group }" ]
  key_pair        = "${ var.keypair }"

  user_data       = "${ element(split("`", var.cloud_init), count.index) }"

  network {
    uuid = "${ var.network_id }"
  }
}
