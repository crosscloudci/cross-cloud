# output "ca" { value = "${ tls_self_signed_cert.ca_cert.cert_pem }" }
# output "ca_key" { value = "${ tls_private_key.ca_key.private_key_pem }" }

# output "master" { value = "${ tls_locally_signed_cert.master_cert.cert_pem}" }
# output "master_key" { value = "${ tls_private_key.master_key.private_key_pem }" }

# output "worker" { value = "${ tls_locally_signed_cert.worker_cert.cert_pem}" }
# output "worker_key" { value = "${ tls_private_key.worker_key.private_key_pem}" }

# output "admin" { value = "${ tls_locally_signed_cert.admin_cert.cert_pem }"}
# output "admin_key" { value = "${ tls_private_key.admin_key.private_key_pem }"}

