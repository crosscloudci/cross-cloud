# Clean-up Destroy
resource "null_resource" "cleanup" {

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOF
aws --region ${ var.aws_region } ec2 delete-key-pair --key-name ${ var.aws_key_name } || true
rm -rf ${ var.data_dir }
EOF
  }

}

resource "null_resource" "dummy_dependency3" {
  depends_on = [ "null_resource.cleanup" ]
}
