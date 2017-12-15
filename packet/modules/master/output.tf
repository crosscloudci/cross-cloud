output "nameserver" { value = "${ packet_device.masters.0.network.0.address }" }
