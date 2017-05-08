resource "aws_instance" "etcd" {
  count = "${ var.master_node_count }"

  ami = "${ var.ami_id }"
  associate_public_ip_address = false
  iam_instance_profile = "${ var.instance_profile_name }"
  instance_type = "${ var.instance_type }"
  key_name = "${ var.key_name }"

  root_block_device {
    volume_size = 124
    volume_type = "gp2"
  }

  source_dest_check = false
  subnet_id = "${ element( split(",", var.subnet_ids_private), 0 ) }"

  tags {
    builtWith = "terraform"
    KubernetesCluster = "${ var.name }" # used by kubelet's aws provider to determine cluster
    kz8s = "${ var.name }"
    Name = "etcd${ count.index + 1 }-${ var.name }"
    role = "etcd,apiserver"
    version = "${ var.kubelet_image_tag }"
    visibility = "private"
  }

  user_data = "${ element(data.template_file.cloud-config.*.rendered, count.index) }"
  vpc_security_group_ids = [ "${ var.etcd_security_group_id }" ]
}

resource "null_resource" "dummy_dependency" {
  depends_on = [ "aws_instance.etcd" ]
}
