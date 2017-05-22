resource "tls_private_key" "worker_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "tls_cert_request" "worker_csr" {
  key_algorithm = "${tls_private_key.worker_key.algorithm}"
  private_key_pem = "${tls_private_key.worker_key.private_key_pem}"
  subject {
    common_name = "${var.tls_worker_cert_subject_common_name}"
  }

  ip_addresses = [
    "${ split(",", var.tls_worker_cert_ip_addresses) }"
  ]

  dns_names = [
    "${ split(",", var.tls_worker_cert_dns_names) }"
  ]
}

resource "tls_locally_signed_cert" "worker_cert" {
  cert_request_pem = "${tls_cert_request.worker_csr.cert_request_pem}"
  ca_key_algorithm = "${tls_private_key.ca_key.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca_key.private_key_pem}"
  ca_cert_pem = "${tls_self_signed_cert.ca_cert.cert_pem}"
  validity_period_hours = "${var.tls_worker_cert_validity_period_hours}"
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth"
  ]
  early_renewal_hours = "${var.tls_worker_cert_early_renewal_hours}"
}


