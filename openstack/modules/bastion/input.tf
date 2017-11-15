variable name { default = "bastion" }
variable "bastion_image_name" { default = "CentOS Linux 7 (Core) [2017-02-10]" }
variable "bastion_flavor_name" { default = "v1-standard-1" }
variable "public_network" { default = "6d6357ac-0f70-4afa-8bd7-c274cc4ea235"}
variable "private_network_id" {}
variable "floating_ip_pool" { default = "public" }
