output "public_master_ips" {
  value = "${oci_core_instance.K8sMaster.*.public_ip}"
}

output "private_master_ips" {
  value = "${oci_core_instance.K8sMaster.*.private_ip}"
}

output "private_master_ips_string" {
  value = "${join(",", oci_core_instance.K8sMaster.*.private_ip)}"
}

output "public_master_ips_string" {
  value = "${join(",", oci_core_instance.K8sMaster.*.public_ip)}"
}
