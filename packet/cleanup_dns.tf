resource "null_resource" "cleanup" {

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOF
    curl -L http://"${ var.etcd_bootstrap }"/v2/keys/skydns/local/packet/e"${ var.name }"\?recursive\=true -XDELETE
    curl -L http://"${ var.etcd_bootstrap }"/v2/keys/skydns/local/packet/i"${ var.name }"\?recursive\=true -XDELETE
EOF
  }


}

resource "null_resource" "dummy_dependency" {
  depends_on = [ "null_resource.cleanup" ]
}