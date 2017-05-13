resource "tls_private_key" "client_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "tls_cert_request" "client_csr" {
  key_algorithm = "${tls_private_key.client_key.algorithm}"
  private_key_pem = "${tls_private_key.client_key.private_key_pem}"
  subject {
    common_name = "${var.tls_client_cert_subject_common_name}"
  }
}

resource "tls_locally_signed_cert" "client_cert" {
  cert_request_pem = "${tls_cert_request.client_csr.cert_request_pem}"
  ca_key_algorithm = "${tls_private_key.client_key.algorithm}"
  ca_private_key_pem = "${tls_private_key.client_key.private_key_pem}"
  ca_cert_pem = "${tls_self_signed_cert.ca_cert.cert_pem}"
  validity_period_hours = "${var.tls_client_cert_validity_period_hours}"
  allowed_uses = [
    "key_encipherment",
    "client_auth",
  ]
  early_renewal_hours = "${var.tls_client_cert_early_renewal_hours}"
}

resource "null_resource" "admin-ssl" {

  provisioner "local-exec" {
    command = <<LOCAL_EXEC
echo "${tls_locally_signed_cert.client_cert.cert_pem}" > admin.pem
echo "${tls_private_key.client_key.private_key_pem}" > admin-key.pem
LOCAL_EXEC
  }
}
