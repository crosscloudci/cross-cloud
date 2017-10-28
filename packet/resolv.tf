#Configure Resolve.conf
resource "null_resource" "resolve_conf" {

  provisioner "local-exec" {
    command = <<EOF
echo -e "nameserver "${ module.master.nameserver }"\n$(cat /etc/resolve.conf)" > /etc/resolv.conf
EOF
  }

}
