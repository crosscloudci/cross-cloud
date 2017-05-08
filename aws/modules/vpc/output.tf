output "depends_id" { value = "${null_resource.dummy_dependency.id}" }
output "id" { value = "${ aws_vpc.main.id }" }
output "subnet_ids_private" { value = "${ join(",", aws_subnet.private.*.id) }" }
output "subnet_ids_public" { value = "${ join(",", aws_subnet.public.*.id) }" }

#output "gateway_id" { value = "${ aws_internet_gateway.main.id }" }
#output "route_table_id" { value = "${ aws_route_table.private.id }" }
