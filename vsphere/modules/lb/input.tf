variable lb_port {
  default = "6443"
}

variable subnet_id {
  default = "subnet-fdee56b6"
}

variable "vpc_id" {
  default = "vpc-8f7048f6"
}

variable "master_ips" {
  type = "list"
}
