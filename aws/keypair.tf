# Add AWS Keypair
resource "null_resource" "aws_keypair" {
  provisioner "local-exec" {
    command = <<EOF
aws --region ${ var.aws_region } ec2 create-key-pair \
 --key-name  ${ var.aws_key_name } \
 --query 'KeyMaterial' \
 --output text \
 > ${ var.data_dir }/${ var.aws_key_name }.pem
chmod 400 ${ var.data_dir }/${ var.aws_key_name }.pem
EOF
  }
}

resource "null_resource" "dummy_dependency2" {
  depends_on = [ "null_resource.aws_keypair" ]
}
