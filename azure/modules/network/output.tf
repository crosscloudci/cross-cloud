output "subnet_id" { value = "${ data.azurerm_subnet.cncf.id }" }
output "vitual_network_id" { value = "${ azurerm_virtual_network.cncf.id }" }

