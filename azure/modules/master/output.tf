output "master_ips" { value = "${ join(",", azurerm_network_interface.cncf.*.private_ip_address) }" }
output "public_master_ips" { value = "${ join(",", azurerm_public_ip.master.*.ip_address) }" }