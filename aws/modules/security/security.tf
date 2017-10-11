resource "aws_security_group" "bastion" {
  description = "bastion-${ var.name }"

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "${ var.allow_ssh_cidr }" ]
  }

  name = "bastion-${ var.name }"

  tags {
    KubernetesCluster = "${ var.name }"
    Name = "${ var.name }"
  }

  vpc_id = "${ var.vpc_id }"
}

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

  name = "master-${ var.name }"

  tags {
    KubernetesCluster = "${ var.name }"
    Name = "master-${ var.name }"
  }

  vpc_id = "${ var.vpc_id }"
}

resource "aws_security_group" "internal_lb" {
  description = "internal-lb-${ var.name }"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [ "${ aws_security_group.master.id }" ]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  name = "internal-lb-${ var.name }"

  tags {
    KubernetesCluster = "${ var.name }"
    Name = "interanl-lb-${ var.name }"
  }

  vpc_id = "${ var.vpc_id }"
}

resource "aws_security_group" "external_lb" {
  description = "external-lb-${ var.name }"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [ "${ aws_security_group.master.id }" ]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  name = "external-lb-${ var.name }"

  tags {
    KubernetesCluster = "${ var.name }"
    Name = "external-lb-${ var.name }"
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
