output "depends_id" { value = "${null_resource.dummy_dependency.id}" }
output "internal_name_servers" { value = "${ aws_route53_zone.internal.name_servers }" }
output "internal_zone_id" { value = "${ aws_route53_zone.internal.zone_id }" }
