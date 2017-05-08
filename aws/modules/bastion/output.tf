output "depends_id" { value = "${null_resource.dummy_dependency.id}" }
output "ip" { value = "${ aws_instance.bastion.public_ip }" }
