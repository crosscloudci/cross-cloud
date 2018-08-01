output "worker_ips" {
  value = "${join(",", oci_core_instance.K8sWorker.*.public_ip)}"
}