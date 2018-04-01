resource "aws_instance" "worker" {
  count = "${ var.worker_node_count }"

  ami = "${ var.ami_id }"
  iam_instance_profile = "${ var.instance_profile_name }"
  instance_type = "${ var.instance_type }"
  key_name = "${ var.aws_key_name }"

  source_dest_check = false
  associate_public_ip_address = true
  subnet_id = "${ var.subnet_id }"
  vpc_security_group_ids = [ "${ var.security_group_id }" ]

  root_block_device {
    volume_size = 52
    volume_type = "gp2"
  }

  tags {
    KubernetesCluster = "${ var.name }" # used by kubelet's aws provider to determine cluster
    Name = "${ var.name }-worker${ count.index + 1 }"
  }

    user_data = "${ base64gzip(element(split(",", var.worker_cloud_init), count.index)) }"
}

