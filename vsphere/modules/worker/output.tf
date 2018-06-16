output "worker_ips" {
  value = "${ join(",", vsphere_virtual_machine.worker.*.default_ip_address) }"
}
