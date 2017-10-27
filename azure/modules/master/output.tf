output "external_lb" { value = "${ azurerm_lb_backend_address_pool.cncf.id }" }
output "fqdn_lb" { value = "${ azurerm_public_ip.cncf.fqdn }" }

