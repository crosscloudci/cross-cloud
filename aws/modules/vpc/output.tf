output "vpc_id" { value = "${ aws_vpc.cncf.id }" }
output "subnet_id" { value = "${ aws_subnet.cncf.id }" }

