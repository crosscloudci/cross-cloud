output "master_ips" {
  value = "${ join(",", vsphere_virtual_machine.master.*.default_ip_address) }"
}
