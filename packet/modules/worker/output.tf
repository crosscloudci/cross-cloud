#output "fqdn_lb" { value = "${azurerm_public_ip.cncf.fqdn}" }
output "public_worker_ips" { value = ["${ packet_device.workers.*.network.0.address }"] }
