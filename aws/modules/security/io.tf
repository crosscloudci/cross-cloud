variable "allow_ssh_cidr" {}
variable "vpc_cidr" {}
variable "name" {}
variable "vpc_id" {}

output "bastion_id" { value = "${ aws_security_group.bastion.id }" }
output "etcd_id" { value = "${ aws_security_group.etcd.id }" }
output "external_elb_id" { value = "${ aws_security_group.external_elb.id }" }
output "worker_id" { value = "${ aws_security_group.worker.id }" }
