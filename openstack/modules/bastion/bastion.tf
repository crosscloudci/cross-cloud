resource "openstack_compute_floatingip_v2" "bastion_fip" {
  pool = "${var.floating_ip_pool}"
}

resource "openstack_compute_instance_v2" "bastion" {
  name = "bastion"
  image_name = "${ var.bastion_image_name }"
  flavor_name = "${ var.bastion_flavor_name }"
  security_groups = [ "default" ]
  key_pair = "K8s"

  network {
    uuid = "${ var.private_network_id }"
  }
}

resource "openstack_compute_floatingip_associate_v2" "bastion_fip" {
  floating_ip = "${openstack_compute_floatingip_v2.bastion_fip.address}"
  instance_id = "${openstack_compute_instance_v2.bastion.id}"
  fixed_ip = "${openstack_compute_instance_v2.bastion.network.0.fixed_ip_v4}"
}
