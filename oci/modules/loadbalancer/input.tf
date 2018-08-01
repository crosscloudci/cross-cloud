variable "compartment_id" {}
variable "lb_subnet_0_id" {}
variable "lb_subnet_1_id" {}
variable "shape" {}
variable "is_private" {}
variable "label_prefix" {}
variable "k8sMasterAd1Count" {}
variable "k8smaster_ad1_private_ips" {
  type    = "list"
  default = []
}
