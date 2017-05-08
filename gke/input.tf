variable "name" { default = "gkecluster" }
variable "region" { default = "us-central1" }
variable "zone" { default = "us-central1-a" }
variable "project" { default = "test-163823" }
variable "cidr" { default = "10.0.0.0/16" }
variable "node_count" { default = "3" }
variable "node_version" { default = "1.6.2" }
variable "master_user" { default = "cncf" }
variable "master_password" { default = "demo"}
variable "vm_size" { default = "n1-standard-1"}
variable "node_pool_count" { default = "3"}
variable "data_dir" { default = "/cncf/data" }

