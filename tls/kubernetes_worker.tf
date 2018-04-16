resource "tls_private_key" "worker_key" {
  count = "${ var.worker_node_count }"
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "tls_cert_request" "worker_csr" {
  count = "${ var.worker_node_count }"
  key_algorithm = "${ element( tls_private_key.worker_key.*.algorithm, count.index )}"
  private_key_pem = "${ element( tls_private_key.worker_key.*.private_key_pem, count.index )}"
  subject {
    common_name = "${var.tls_worker_cert_subject_common_name}-${ count.index +1 }.${var.tls_worker_cert_subject_common_name_suffix}"
    locality = "${var.tls_worker_cert_subject_locality}"
    organization = "${var.tls_worker_cert_subject_organization}"
    organizational_unit = "${var.tls_worker_cert_subject_organization_unit}"
    province = "${var.tls_worker_cert_subject_province}"
    country = "${var.tls_worker_cert_subject_country}"
  }

  ip_addresses = [
    "${ split(",", var.tls_worker_cert_ip_addresses) }"
  ]

  dns_names = [
    "${ split(",", var.tls_worker_cert_dns_names) }"
  ]
}

resource "tls_locally_signed_cert" "worker_cert" {
  count = "${ var.worker_node_count }"
  cert_request_pem = "${ element( tls_cert_request.worker_csr.*.cert_request_pem, count.index )}"
  ca_key_algorithm = "${tls_private_key.ca_key.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca_key.private_key_pem}"
  ca_cert_pem = "${tls_self_signed_cert.ca_cert.cert_pem}"
  validity_period_hours = "${var.tls_worker_cert_validity_period_hours}"
  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "code_signing",
    "ocsp_signing",
    "key_encipherment",
    "server_auth",
    "client_auth"
  ]
  early_renewal_hours = "${var.tls_worker_cert_early_renewal_hours}"
}


