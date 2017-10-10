variable "ami_id" {}
variable "capacity" {
  default = {
    desired = 5
    max = 5
    min = 3
  }
}
variable "instance_profile_name" {}
variable "instance_type" {}
variable "key_name" {}
variable "name" {}
variable "region" {}
variable "security_group_id" {}
variable "subnet_private_id" {}
variable "worker_cloud_init" {}
