resource "aws_elb" "external" {
  name = "e${ var.name }"

  cross_zone_load_balancing = false

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 6
    timeout = 3
    target = "SSL:443"
    interval = 10
  }

  idle_timeout = 3600

  listener {
    instance_port = 443
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }

  security_groups = [ "${ var.external_lb_security }" ]
  subnets = [ "${ var.subnet_public_id }" ]

  tags {
    Name = "external-${ var.name }"
    KubernetesCluster = "${ var.name }"
  }
}

resource "aws_elb_attachment" "master_external" {
  count = "${ var.master_node_count }"

  elb      = "${ aws_elb.external.id }"
  instance = "${ element(aws_instance.master.*.id, count.index) }"
}
