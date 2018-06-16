# Please see ../input_lb.tf for documentation on the variables
# defined below.

variable "name" {}

variable "count" {}

variable "port" {}

variable "subnet_id" {}

variable "target_ips" {
  type = "list"
}

variable "target_port" {}

variable "vpc_id" {}

variable "vsphere_aws_access_key_id" {}

variable "vsphere_aws_secret_access_key" {}

variable "vsphere_aws_region" {}
