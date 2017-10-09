resource "aws_network_interface" "master" {
  count = "${ var.master_node_count }"
  subnet_id = "${ var.subnet_private_id }"
  private_ips = [ "${ var.subnet_prefix }.${ count.index + 10 }" ]
  security_groups = [ "${ var.master_security }" ]
  source_dest_check = false
}

resource "aws_instance" "master" {
  count = "${ var.master_node_count }"

  ami = "${ var.ami_id }"
  iam_instance_profile = "${ var.instance_profile_name }"
  instance_type = "${ var.instance_type }"
  key_name = "${ var.key_name }"

  network_interface {
    device_index = 0
    network_interface_id = "${ element(aws_network_interface.master.*.id, count.index) }"
  }

  root_block_device {
    volume_size = 124
    volume_type = "gp2"
  }

  tags {
    KubernetesCluster = "${ var.name }" # used by kubelet's aws provider to determine cluster
    Name = "etcd${ count.index + 1 }-${ var.name }"
  }

  user_data = "${ base64gzip(element(split(",", var.master_cloud_init), count.index)) }"
}
