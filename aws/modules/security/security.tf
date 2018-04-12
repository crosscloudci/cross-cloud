
resource "aws_security_group" "master" {
  description = "master-${ var.name }"

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    /*self = true*/
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
    cidr_blocks = [ "${ var.vpc_cidr }" ]
  }

  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress = {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  name = "master-${ var.name }"

  tags {
    KubernetesCluster = "${ var.name }"
    Name = "master-${ var.name }"
  }

  vpc_id = "${ var.vpc_id }"
}

resource "aws_security_group" "worker" {
  description = "k8s worker security group"

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    /*self = true*/
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
    cidr_blocks = [ "${ var.vpc_cidr }" ]
  }

  name = "worker-${ var.name }"

  tags {
    KubernetesCluster = "${ var.name }"
    Name = "worker-${ var.name }"
  }

  vpc_id = "${ var.vpc_id }"
}
