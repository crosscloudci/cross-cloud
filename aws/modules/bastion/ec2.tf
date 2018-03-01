resource "aws_instance" "bastion" {
  ami = "${ var.ami_id }"
  associate_public_ip_address = true
  instance_type = "${ var.instance_type }"
  key_name = "${ var.aws_key_name }"

  # TODO: force private_ip to prevent collision with etcd machines

  source_dest_check = false
  subnet_id = "${ var.subnet_public_id }"

  tags  {
    builtWith = "terraform"
    kz8s = "${ var.name }"
    Name = "kz8s-bastion"
    role = "bastion"
  }

  # user_data = "${ data.template_file.user-data.rendered }"

  vpc_security_group_ids = [
    "${ var.security_group_id }",
  ]
}

data "template_file" "user-data" {
  template = "${ file( "${ path.module }/user-data.yml" )}"

  vars {
  }
}

resource "null_resource" "dummy_dependency" {
  depends_on = [ "aws_instance.bastion" ]
}
