#Configure Resolve.conf
resource "null_resource" "resolv_conf" {

  provisioner "local-exec" {
    command = <<EOF
echo "nameserver "${ module.master.nameserver }"\n$(cat /etc/resolv.conf)" > /etc/resolv.conf
echo "#nameserver ${ module.master.nameserver } >> ${ var.data_dir }/kubeconfig"
EOF
  }

}
