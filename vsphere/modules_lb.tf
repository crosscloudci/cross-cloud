module "lb" {
  source = "./modules/lb"

  count = "${var.master_node_count}"

  lb_port        = "${var.lb_port}"
  lb_subnet_id   = "${var.lb_subnet_id}"
  lb_target_ips  = ["${split(",", module.master.master_ips)}"]
  lb_target_port = "${var.lb_target_port}"
  lb_vpc_id      = "${var.lb_vpc_id}"

  vsphere_aws_access_key_id     = "${var.vsphere_aws_access_key_id}"
  vsphere_aws_secret_access_key = "${var.vsphere_aws_secret_access_key}"
  vsphere_aws_region            = "${var.vsphere_aws_region}"
}
