module "load_balancer" {
  source = "./modules/load_balancer"

  count = "${var.master_node_count}"
  name  = "${var.name}"

  port        = "${var.lb_port}"
  subnet_id   = "${var.lb_subnet_id}"
  target_ips  = ["${split(",", module.master.master_ips)}"]
  target_port = "${var.lb_target_port}"
  vpc_id      = "${var.lb_vpc_id}"

  vsphere_aws_access_key_id     = "${var.vsphere_aws_access_key_id}"
  vsphere_aws_secret_access_key = "${var.vsphere_aws_secret_access_key}"
  vsphere_aws_region            = "${var.vsphere_aws_region}"
}
