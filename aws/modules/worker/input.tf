variable "ami_id" {}
variable "capacity" {
  default = {
    desired = 5
    max = 5
    min = 3
  }
}
variable "cluster_domain" {}
variable "kubelet_image_url" {}
variable "kubelet_image_tag" {}
variable "depends_id" {}
variable "dns_service_ip" {}
variable "instance_type" {}
variable "internal_tld" {}
variable "key_name" {}
variable "name" {}
variable "region" {}
variable "security_group_id" {}
variable "subnet_ids" {}
variable "volume_size" {
  default = {
    ebs = 250
    root = 52
  }
}
variable "vpc_id" {}
variable "worker_name" {}
variable "ca" {}
variable "k8s_worker" {}
variable "k8s_worker_key" {}
variable "instance_profile_name" {}
# variable "s3_bucket" {}
