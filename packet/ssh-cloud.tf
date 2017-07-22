#Gen SSH KeyPair
resource "null_resource" "ssh_gen" {

  provisioner "local-exec" {
    command = <<EOF
mkdir -p ${ var.data_dir }/.ssh
ssh-keygen -t rsa -f ${ var.data_dir }/.ssh/id_rsa -N ''
EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOF
    rm -rf ${ var.data_dir }/.ssh
EOF
  }

  provisioner "local-exec" {
    command = <<EOF
    packet admin -k ${ var.packet_api_key } create-sshkey --label ${ var.name } --file ${ var.data_dir}/.ssh/id_rsa.pub
EOF
  }

}

resource "null_resource" "set_dns" {

  provisioner "local-exec" {
    command = <<EOF
    echo "${ module.etcd.first_master_ip } endpoint.${ var.name }.${ var.domain }" >> /etc/resolv.conf
    EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOF
    echo FIX ME
EOF
  }
}

resource "null_resource" "dummy_dependency" {
  depends_on = [ "null_resource.set_dns" ]
}

