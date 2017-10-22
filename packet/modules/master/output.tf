#output "fqdn_lb" { value = "${azurerm_public_ip.cncf.fqdn}" }
output "first_master_ip" { value = "${ packet_device.masters.0.network.0.address }" }
output "second_master_ip" { value = "${ packet_device.masters.1.network.0.address }" }
output "third_master_ip" { value = "${ packet_device.masters.2.network.0.address }" }
output "master_ips" { value = ["${ packet_device.masters.*.network.2.address }"] }
output "public_master_ips" { value = ["${ packet_device.masters.*.network.0.address }"] }
