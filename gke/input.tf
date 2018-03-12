variable "name" { default = "gkecluster" }
variable "region" { default = "us-central1" }
variable "zone" { default = "us-central1-a" }
variable "cidr" { default = "10.0.0.0/16" }
variable "image_type" { default = "ubuntu" }
variable "node_count" { default = "1" }
variable "node_version" { default = "1.9.3-gke.0" }
variable "min_master_version" { default = "1.9.3-gke.0" } 
variable "master_user" { default = "cncf" }
variable "master_password" { default = "Thae6quuisaiLieG"}
variable "vm_size" { default = "n1-standard-32"}
variable "data_dir" { default = "/cncf/data" }
variable "google_project" {}

