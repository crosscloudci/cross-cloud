# General settings
variable "name" { default = "openstack" }
variable "data_dir" { default = "/cncf/data/openstack" }

# TLS settings
variable "cloud_location" { default = "vexxhost.com" }

# Compute resources
variable "master_flavor_name" { default = "v1-standard-1" }
variable "master_image_name"  { default = "CoreOS 1298.6.0 (MoreOS) [2017-03-15]" }
variable "master_count"       { default = "3" }

variable "node_flavor_name" { default = "v1-standard-1" }
variable "node_image_name"  { default = "CoreOS 1298.6.0 (MoreOS) [2017-03-15]" }
variable "node_count"       { default = "3" }

# Network resources
variable "public_network"       { default = "6d6357ac-0f70-4afa-8bd7-c274cc4ea235" }
variable "private_network_cidr" { default = "192.168.11.0/24" }
variable "private_lb_ip"        { default = "192.168.11.250" }
