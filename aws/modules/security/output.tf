output "bastion_id" { value = "${ aws_security_group.bastion.id }" }
output "master_id" { value = "${ aws_security_group.master.id }" }
output "external_lb_id" { value = "${ aws_security_group.external_lb.id }" }
output "worker_id" { value = "${ aws_security_group.worker.id }" }
