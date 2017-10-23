resource "aws_instance" "master" {
  count = "${ var.master_node_count }"

  ami = "${ var.ami_id }"
  iam_instance_profile = "${ var.instance_profile_name }"
  instance_type = "${ var.instance_type }"
  key_name = "${ var.key_name }"

  source_dest_check = false
  associate_public_ip_address = false
  subnet_id = "${ var.subnet_private_id }"
  vpc_security_group_ids = [ "${ var.master_security }" ]

  root_block_device {
    volume_size = 124
    volume_type = "gp2"
  }

  tags {
    KubernetesCluster = "${ var.name }" # used by kubelet's aws provider to determine cluster
    Name = "${ var.name }-master${ count.index + 1 }"
  }

  user_data = "${ base64gzip(element(split(";", var.master_cloud_init), count.index)) }"
}
