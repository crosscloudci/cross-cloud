#Gen Certs and SSH KeyPair
resource "null_resource" "ssl_ssh_gen" {

  provisioner "local-exec" {
    command = <<EOF
${ path.module }/init-cfssl \
${ var.data_dir }/.cfssl \
${ var.packet_facility } \
${ var.name }.${ var.domain } \
${ var.k8s_service_ip }
EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOF
rm -rf ${ var.data_dir }/.cfssl
EOF
  }

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

resource "null_resource" "dummy_dependency" {
  depends_on = [ "null_resource.ssl_ssh_gen" ]
}

