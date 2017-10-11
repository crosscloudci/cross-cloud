resource "aws_vpc" "cncf" {
  cidr_block = "${ var.cidr }"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    KubernetesCluster = "${ var.name }"
    Name = "kz8s-${ var.name }"
  }
}
