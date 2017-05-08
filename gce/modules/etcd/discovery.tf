
#Get Discovery URL
resource "null_resource" "discovery_gen" {

  provisioner "local-exec" {
    command = <<EOF
curl https://discovery.etcd.io/new?size=${ var.master_node_count } > ${ var.etcd_discovery }
EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOF
rm -rf ${ var.etcd_discovery }
EOF
  }

}
