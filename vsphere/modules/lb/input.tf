# Please see ../input_lb.tf for documentation on the variables
# defined below.

variable "name" {}

variable "count" {}

variable "lb_port" {}

variable "lb_subnet_id" {}

variable "lb_target_ips" {
  type = "list"
}

variable "lb_target_port" {}

variable "lb_vpc_id" {}

variable "vsphere_aws_access_key_id" {}

variable "vsphere_aws_secret_access_key" {}

variable "vsphere_aws_region" {}
