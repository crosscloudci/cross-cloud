variable "name" {}

// The datacenter the resources will be created in.
variable "datacenter" {
  type = "string"
}

// The resource pool the virtual machines will be placed in.
variable "resource_pool" {
  type = "string"
}

# cpu_limit is the max MHz an environment can consume
variable "cpu_limit" {
  type = "string"
}

# memory_limit is the max MB an environment can consume
variable "memory_limit" {
  type = "string"
}
