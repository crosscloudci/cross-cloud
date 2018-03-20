resource "openstack_compute_instance_v2" "loadbalancer" {
  name            = "${ var.name }-loadbalancer"
  image_name      = "${ var.image }"
  flavor_name     = "${ var.flavor }"
  security_groups = [ "${ var.security_group }" ]
  key_pair        = "${ var.keypair }"

  user_data       = "${ data.template_file.cloud_config.rendered }"

  network {
    port = "${ var.lb_port }"
  }
}

resource "openstack_compute_floatingip_associate_v2" "loadbalancer" {
  floating_ip = "${ var.fip }"
  instance_id = "${ openstack_compute_instance_v2.loadbalancer.id }"
  fixed_ip    = "${ openstack_compute_instance_v2.loadbalancer.network.0.fixed_ip_v4 }"
}

data "template_file" "cloud_config" {
  template = "${ file( "${ path.module }/cloud-config.yml" )}"

  vars {
    server_ips = "${ join("\n", formatlist("          server %s:443;", var.master_ips)) }"
#     server_ips = "${ join("\n", flatten(var.master_ips)) }"
  }
}
