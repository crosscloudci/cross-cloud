output "fqdn_k8s" { value = "${ google_container_cluster.cncf.endpoint }" }
