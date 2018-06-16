# resource_pool_cpu_limit is the limit in MHz of CPU that
# an environment can consume
variable "resource_pool_cpu_limit" {
  default = "128000"
}

# resource_pool_memory_limit is the limit in MB of memory that
# an environment can consume
variable "resource_pool_memory_limit" {
  default = "262144"
}
