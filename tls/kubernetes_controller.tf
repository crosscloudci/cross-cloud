resource "tls_private_key" "controller_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "tls_cert_request" "controller_csr" {
  key_algorithm = "${tls_private_key.controller_key.algorithm}"
  private_key_pem = "${tls_private_key.controller_key.private_key_pem}"
  subject {
    common_name = "${var.tls_controller_cert_subject_common_name}"
    locality = "${var.tls_controller_cert_subject_locality}"
    organization = "${var.tls_controller_cert_subject_organization}"
    organizational_unit = "${var.tls_controller_cert_subject_organization_unit}"
    province = "${var.tls_controller_cert_subject_province}"
    country = "${var.tls_controller_cert_subject_country}"
    
  }

  ip_addresses = [
    "${ split(",", var.tls_controller_cert_ip_addresses) }"
  ]

  dns_names = [
    "${ split(",", var.tls_controller_cert_dns_names) }"
  ]

}

resource "tls_locally_signed_cert" "controller_cert" {
  cert_request_pem = "${tls_cert_request.controller_csr.cert_request_pem}"
  ca_key_algorithm = "${tls_private_key.ca_key.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca_key.private_key_pem}"
  ca_cert_pem = "${tls_self_signed_cert.ca_cert.cert_pem}"
  validity_period_hours = "${var.tls_controller_cert_validity_period_hours}"
  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "code_signing",
    "ocsp_signing",
    "key_encipherment",
    "server_auth",
    "client_auth"
  ]
  early_renewal_hours = "${var.tls_controller_cert_early_renewal_hours}"
}