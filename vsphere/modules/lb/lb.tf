provider "aws" {
  access_key = "${var.vsphere_aws_access_key_id}"
  secret_key = "${var.vsphere_aws_secret_access_key}"
  region     = "${var.vsphere_aws_region}"
}

resource "aws_lb" "xapi" {
  name_prefix        = "xapi-"
  load_balancer_type = "network"
  internal           = false
  ip_address_type    = "ipv4"
  subnets            = ["${var.lb_subnet_id}"]
}

resource "aws_lb_target_group" "xapi" {
  name_prefix = "xapi-"
  target_type = "ip"
  port        = "${var.lb_target_port}"
  protocol    = "TCP"
  vpc_id      = "${var.lb_vpc_id}"
}

resource "aws_lb_target_group_attachment" "xapi" {
  count             = "${var.count}"
  target_group_arn  = "${aws_lb_target_group.xapi.arn}"
  target_id         = "${element(var.lb_target_ips, count.index)}"
  port              = "${var.lb_target_port}"
  availability_zone = "all"
}

resource "aws_lb_listener" "xapi" {
  load_balancer_arn = "${aws_lb.xapi.arn}"
  port              = "${var.lb_port}"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.xapi.arn}"
    type             = "forward"
  }
}
