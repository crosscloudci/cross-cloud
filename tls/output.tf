output "ca" { value = "${ tls_self_signed_cert.ca_cert.cert_pem }" }

output "etcd" { value = "${ tls_locally_signed_cert.etcd_cert.cert_pem }" }
output "etcd_key" { value = "${ tls_private_key.etcd_key.private_key_pem }" }

output "apiserver" { value = "${ tls_locally_signed_cert.apiserver_cert.cert_pem}" }
output "apiserver_key" { value = "${ tls_private_key.apiserver_key.private_key_pem }" }

output "worker" { value = "${ tls_locally_signed_cert.worker_cert.cert_pem}" }
output "worker_key" { value = "${ tls_private_key.worker_key.private_key_pem}" }

output "client" { value = "${ tls_locally_signed_cert.client_cert.cert_pem }"}
output "client_key" { value = "${ tls_private_key.client_key.private_key_pem }"}

output "serviceaccount" { value = "${ tls_locally_signed_cert.serviceaccount_cert.cert_pem}" }
output "serviceaccount_key" { value = "${ tls_private_key.serviceaccount_key.private_key_pem}" }

