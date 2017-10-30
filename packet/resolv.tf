#Configure Resolve.conf
resource "null_resource" "resolv_conf" {

  provisioner "local-exec" {
    command = <<EOF
echo -e "nameserver ${ module.master.nameserver }\n$(cat /etc/resolv.conf)" > /etc/resolv.conf
echo -e "nameserver ${ module.master.nameserver }\n$(cat ${ var.data_dir }/kubeconfig)" >> "${ var.data_dir }/kubeconfig"
EOF
  }

}
