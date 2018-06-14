# lb_port is the port on which the load-balancer listens for incoming 
# connections
variable "lb_port" {
  default = "6443"
}

# lb_subnet_id is the ID of the subnet to which the load balancer is
# attached
variable "lb_subnet_id" {
  default = "subnet-fdee56b6"
}

# lb_target_port is the port on which the back-end targets listen for
# incoming connections from the load balancer
variable "lb_target_port" {
  default = "6443"
}

# lb_vpc_id is ID of the VPC to which the load balancer is attached
variable "lb_vpc_id" {
  default = "vpc-8f7048f6"
}

# AWS settings used to configure the load balancer. This should be
# the account linked to the VMC SDDC.
variable "vsphere_aws_access_key_id" {}

variable "vsphere_aws_secret_access_key" {}

variable "vsphere_aws_region" {
  default = "us-west-2"
}
