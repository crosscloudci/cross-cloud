resource "tls_private_key" "ssh" {
  lifecycle {
    create_before_destroy = true
  }

  algorithm = "RSA"
  count     = "${var.ssh_private_key == "" ? 1 : 0}"
  rsa_bits  = 2048
}

resource "null_resource" "ssh_keys" {
  provisioner "local-exec" {
    command = <<LOCAL_EXEC
echo "${var.ssh_public_key == "" ? join(" ", tls_private_key.ssh.*.public_key_openssh) : var.ssh_public_key}" > "${var.data_dir}/ssh_pub"
echo "${var.ssh_private_key == "" ? join(" ", tls_private_key.ssh.*.private_key_pem) : var.ssh_private_key}" > "${var.data_dir}/ssh_priv"
LOCAL_EXEC
  }
}