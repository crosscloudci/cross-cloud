resource "vsphere_resource_pool" "resource_pool" {
  name                    = "${var.name}"
  parent_resource_pool_id = "${data.vsphere_resource_pool.xcloud.id}"
  cpu_limit               = "${var.cpu_limit}"
  memory_limit            = "${var.memory_limit}"
}
