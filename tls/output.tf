output "ca" { value = "${ tls_self_signed_cert.ca_cert.cert_pem }" }
output "ca_key" { value = "${ tls_private_key.ca_key.private_key_pem }" }

output "admin" { value = "${ tls_locally_signed_cert.admin_cert.cert_pem }"}
output "admin_key" { value = "${ tls_private_key.admin_key.private_key_pem }"}

output "apiserver" { value = "${ tls_locally_signed_cert.apiserver_cert.cert_pem }" }
output "apiserver_key" { value = "${ tls_private_key.apiserver_key.private_key_pem }" }

output "controller" { value = "${ tls_locally_signed_cert.controller_cert.cert_pem }" }
output "controller_key" { value = "${ tls_private_key.controller_key.private_key_pem }" }

output "worker" { value = "${ join(",", tls_locally_signed_cert.worker_cert.*.cert_pem) }" }
output "worker_key" { value = "${ join(",", tls_private_key.worker_key.*.private_key_pem) }" }


