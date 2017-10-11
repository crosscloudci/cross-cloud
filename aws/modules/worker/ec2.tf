resource "aws_launch_configuration" "worker" {
  iam_instance_profile = "${ var.instance_profile_name }"
  image_id = "${ var.ami_id }"
  instance_type = "${ var.instance_type }"
  key_name = "${ var.key_name }"

  root_block_device {
    volume_size = 52
    volume_type = "gp2"
  }

  security_groups = [
    "${ var.security_group_id }",
  ]

  user_data = "${ base64gzip(element(split(",", var.worker_cloud_init), 1)) }"

}

resource "aws_autoscaling_group" "worker" {
  name = "worker-${ var.name }"

  desired_capacity = "${ var.capacity["desired"] }"
  health_check_grace_period = 60
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${ aws_launch_configuration.worker.name }"
  max_size = "${ var.capacity["max"] }"
  min_size = "${ var.capacity["min"] }"
  vpc_zone_identifier = [ "${ var.subnet_private_id }" ]

  tag {
    key = "KubernetesCluster"
    value = "${ var.name }"
    propagate_at_launch = true
  }

  tag {
    key = "Name"
    value = "${ var.name }"
    propagate_at_launch = true
  }

}
