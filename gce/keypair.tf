#Create SSH Keypair
resource "null_resource" "sshkey_gen" {

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
}

resource "null_resource" "dummy_dependency2" {
  depends_on = [ "null_resource.sshkey_gen" ]
}
