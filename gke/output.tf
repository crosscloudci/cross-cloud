output "kubeconfig" { value = "${ module.kubeconfig.kubeconfig }"}
output "fqdn_k8s" { value = "${ module.cluster.fqdn_k8s }" }
