resource "tls_private_key" "ca_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "tls_self_signed_cert" "ca_cert" {
  key_algorithm = "${tls_private_key.ca_key.algorithm}"
  private_key_pem = "${tls_private_key.ca_key.private_key_pem}"
  subject {
    common_name = "${var.tls_ca_cert_subject_common_name}"
    organization = "${var.tls_ca_cert_subject_organization}"
    locality = "${var.tls_ca_cert_subject_locality}"
    province = "${var.tls_ca_cert_subject_province}"
    country = "${var.tls_ca_cert_subject_country}"
  }
  validity_period_hours = "${var.tls_ca_cert_validity_period_hours}"
  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "server_auth",
    "client_auth"
  ]
  early_renewal_hours = "${var.tls_etcd_cert_early_renewal_hours}"
  is_ca_certificate = true
}


resource "null_resource" "ssl" {

  provisioner "local-exec" {
    command = <<LOCAL_EXEC
echo "${tls_self_signed_cert.ca_cert.cert_pem}" > "${ var.data_dir}/ca.pem"
echo "${tls_locally_signed_cert.client_cert.cert_pem}" > "${ var.data_dir }/client.pem"
echo "${tls_private_key.client_key.private_key_pem}" > "${ var.data_dir }/client_key.pem"
LOCAL_EXEC
  }
}
