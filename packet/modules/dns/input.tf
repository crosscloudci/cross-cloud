variable "name" {}
variable "master_ips" { type = "list" }
variable "public_master_ips" { type = "list" }
variable "public_worker_ips" { type = "list" }
variable "master_node_count" {}
variable "worker_node_count" {}
variable "domain" {}
variable "record_ttl" { default = "60" }
