resource "aws_network_interface" "etcd" {
  count = "${ var.master_node_count }"
  subnet_id = "${ element( split(",", var.subnet_ids_private), 0 ) }"
  security_groups = [ "${ var.etcd_security_group_id }" ]
  source_dest_check = false
}

resource "aws_instance" "etcd" {
  count = "${ var.master_node_count }"

  ami = "${ var.ami_id }"
  iam_instance_profile = "${ var.instance_profile_name }"
  instance_type = "${ var.instance_type }"
  key_name = "${ var.key_name }"

  network_interface {
    device_index = 0
    network_interface_id = "${ element(aws_network_interface.etcd.*.id, count.index) }"
  }

  root_block_device {
    volume_size = 124
    volume_type = "gp2"
  }

  tags {
    KubernetesCluster = "${ var.name }" # used by kubelet's aws provider to determine cluster
    Name = "etcd${ count.index + 1 }-${ var.name }"
  }

  user_data = "${ element(data.template_file.cloud-config.*.rendered, count.index) }"
}

