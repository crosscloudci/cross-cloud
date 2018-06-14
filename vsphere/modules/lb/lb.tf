provider "aws" {}

resource "aws_lb" "xapi" {
  name_prefix        = "xapi-"
  load_balancer_type = "network"
  internal           = false
  ip_address_type    = "ipv4"
  subnets            = ["${subnet_id}"]
}

resource "aws_lb_target_group" "xapi" {
  name_prefix = "xapi-"
  target_type = "ip"
  port        = "${lb_port}"
  protocol    = "TCP"
  vpc_id      = "${vpc_id}"
}

resource "aws_lb_target_group_attachment" "xapi" {
  count             = "${ var.count }"
  target_group_arn  = "${aws_lb_target_group.xapi.arn}"
  target_id         = "${element(master_ips, count.index)}"
  port              = "${lb_port}"
  availability_zone = "all"
}

resource "aws_lb_listener" "xapi" {
  load_balancer_arn = "${aws_lb.xapi.arn}"
  port              = "${lb_port}"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.xapi.arn}"
    type             = "forward"
  }
}
