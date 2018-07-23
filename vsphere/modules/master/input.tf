variable "name" {}
variable "hostname_suffix" {}
variable "hostname_path" {}
variable "count" {}
variable "cloud_init" {}
variable "num_cpu" {}
variable "num_cores_per_socket" {}
variable "memory" {}

// The datacenter the resources will be created in.
variable "datacenter" {
  type = "string"
}

// The resource pool the virtual machines will be placed in.
variable "resource_pool" {
  type = "string"
}

// The name of the datastore to use.
variable "datastore_name" {
  type = "string"
}

// folder_path is the path of the folder in which the VM
// is created
variable "folder_path" {
  type = "string"
}

// The name of the network to use.
variable "network_name" {
  type = "string"
}

// The name of the template to use when cloning.
variable "template_name" {
  type = "string"
}
