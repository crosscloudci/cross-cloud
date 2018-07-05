// datacenter looks up the datacenter where all resources will be placed.
data "vsphere_datacenter" "datacenter" {
  name = "${var.datacenter}"
}

// resource_pool looks up the resource pool to place the virtual machines in.
data "vsphere_resource_pool" "xcloud" {
  name          = "${var.resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}
