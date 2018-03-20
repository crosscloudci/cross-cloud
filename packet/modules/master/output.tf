output "master_ips" { value = "${ join(",", packet_device.masters.*.access_private_ipv4) }" }

output "public_master_ips" { value = "${ join(",", packet_device.masters.*.access_public_ipv4) }" }
