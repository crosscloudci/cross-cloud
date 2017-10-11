resource "aws_eip" "nat" { vpc = true }

resource "aws_nat_gateway" "nat" {

  allocation_id = "${ aws_eip.nat.id }"
  subnet_id = "${ aws_subnet.public.0.id }"
}

resource "aws_subnet" "private" {
  availability_zone = "${ var.aws_availability_zone }"
  cidr_block = "${ var.subnet_cidr_private }"
  vpc_id = "${ aws_vpc.cncf.id }"

  tags {
    KubernetesCluster = "${ var.name }"
    Name = "${ var.name }-private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${ aws_vpc.cncf.id }"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${ aws_nat_gateway.nat.id }"
  }

  tags {
    KubernetesCluster = "${ var.name }"
    Name = "${ var.name }"
  }
}

resource "aws_route_table_association" "private" {
  route_table_id = "${ aws_route_table.private.id }"
  subnet_id = "${ aws_subnet.private.id }"
}
