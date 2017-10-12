variable "name" { default = "gce" }
variable "master_node_count" { default = "3" }
variable "worker_node_count" { default = "3" }

variable "bastion_vm_size"   { default = "n1-standard-1" }
variable "master_vm_size"    { default = "n1-standard-1" }
variable "image_id"          { default = "coreos-stable-1298-7-0-v20170401"}

variable "region"          { default = "us-central1" }
variable "zone"            { default = "us-central1-a" }
variable "project"         { default = "test-163823" }

variable "cidr" { default = "10.240.0.0/16" }
variable "pod_cidr" { default = "100.96.0.0/11" }
variable "service_cidr"   { default = "100.64.0.0/13" }
variable "dns_service_ip" { default = "100.64.0.10" }
variable "internal_lb_ip" { default = "10.240.0.100"}

variable "allow_ssh_cidr" { default = "0.0.0.0/0" }

variable "data_dir" { default = "/cncf/data/gce" }
