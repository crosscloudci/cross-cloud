output "public_worker_ips" { value = ["${ packet_device.workers.*.network.0.address }"] }
