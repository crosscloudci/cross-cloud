output "bastion_ip" { value = "${azurerm_public_ip.cncf.ip_address}" }
output "bastion_fqdn" { value = "${azurerm_public_ip.cncf.fqdn}" }
