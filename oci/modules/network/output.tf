output "k8s_subnet_ad1_id" {
  value = "${oci_core_subnet.K8sSubnetAD1.id}"
}

output "k8s_subnet_ad2_id" {
  value = "${oci_core_subnet.K8sSubnetAD2.id}"
}

output "lb_subnet_ad1_id" {
  value = "${oci_core_subnet.LbSubnetAD1.id}"
}

output "lb_subnet_ad2_id" {
  value = "${oci_core_subnet.LbSubnetAD2.id}"
}