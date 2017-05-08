# variable "s3_bucket" {}
# variable "depends_id" {}
variable "name" {}

output "depends_id" { value = "${ null_resource.dummy_dependency.id }" }
output "aws-iam-role-etcd-id" { value = "${ aws_iam_role.master.id }" }
output "aws-iam-role-worker-id" { value = "${ aws_iam_role.worker.id }" }
output "instance_profile_name_master" { value = "${ aws_iam_instance_profile.master.name }" }
output "instance_profile_name_worker" { value = "${ aws_iam_instance_profile.worker.name }" }
