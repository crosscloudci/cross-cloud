output "autoscaling_group_name" { value = "${ aws_autoscaling_group.worker.name }" }
output "depends_id" { value = "${ null_resource.dummy_dependency.id }" }
