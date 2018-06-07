// datacenter looks up the datacenter where all resources will be placed.
data "vsphere_datacenter" "datacenter" {
  name = "${var.datacenter}"
}

// resource_pool looks up the resource pool to place the virtual machines in.
data "vsphere_resource_pool" "resource_pool" {
  name          = "${var.resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

// datastore looks up the datastore to place the virtual machines in.
data "vsphere_datastore" "datastore" {
  name          = "${var.datastore_name}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

// network looks up the network to place the virtual machines in.
data "vsphere_network" "network" {
  name          = "${var.network_name}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

// template looks up the template to create the virtual machines as.
data "vsphere_virtual_machine" "template" {
  name          = "${var.template_name}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

// convert cloud_init to ignitation config
data "ct_config" "worker" {
  count = "${ var.count }"
  content      = "${ element(split("`", var.cloud_init), count.index) }"
  platform     = "custom"
  pretty_print = false
}
