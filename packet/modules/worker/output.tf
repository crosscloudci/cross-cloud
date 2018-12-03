output "worker_ips" { value = "${ join(",", packet_device.workers.*.access_private_ipv4) }" }

output "public_worker_ips" { value = "${ join(",", packet_device.workers.*.access_public_ipv4) }" }