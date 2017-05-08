# output "depends_id" { value = "${null_resource.dummy_dependency.id}" }
output "internal_name_servers" { value = "${ azurerm_dns_zone.cncf.name_servers }" }
output "internal_zone_id" { value = "${ azurerm_dns_zone.cncf.zone_id }" }
output "name_servers_file" { value = "${ var.name_servers_file }" }
