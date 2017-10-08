resource "aws_elb" "external" {
  name = "k8-api-${replace(var.name, "/(.{0,25})(.*)/", "$1")}"

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

  security_groups = [ "${ var.external_elb_security_group_id }" ]
  subnets = [ "${ var.subnet_id }" ]

  tags {
    Name = "${ var.name }"
    KubernetesCluster = "${ var.name }"
  }
}

resource "aws_elb_attachment" "master" {
  count = "${ var.master_node_count }"

  elb      = "${ aws_elb.external.id }"
  instance = "${ element(aws_instance.master.*.id, count.index) }"
}
