module "resource_pool" {
  source = "./modules/resource_pool"

  name = "${var.name}"

  datacenter    = "${var.datacenter}"
  resource_pool = "${var.resource_pool}"

  cpu_limit    = "${var.resource_pool_cpu_limit}"
  memory_limit = "${var.resource_pool_memory_limit}"
}
