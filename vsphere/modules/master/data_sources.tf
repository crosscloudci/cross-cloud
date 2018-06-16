// datacenter looks up the datacenter where all resources will be placed.
data "vsphere_datacenter" "datacenter" {
  name = "${var.datacenter}"
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

// virtual_machine_network_content renders a template with the systemd-networkd unit
// content for a specific virtual machine.
data "template_file" "virtual_machine_network_content" {
  count    = "${ var.count }"
  template = "${file("${path.module}/files/00-ens192.network.tpl")}"

  vars = {
    address = "${cidrhost(var.virtual_machine_network_address, var.virtual_machine_ip_address_start + count.index)}"
    mask    = "${ element(split("/", var.virtual_machine_network_address), 1) }"
    gateway = "${var.virtual_machine_gateway}"
    dns     = "${join("\n", formatlist("DNS=%s", var.virtual_machine_dns_servers))}"
  }
}

// virtual_machine_network_unit defines the systemd network units for
// each virtual machine.
data "ignition_networkd_unit" "virtual_machine_network_unit" {
  count   = "${ var.count }"
  name    = "00-ens192.network"
  content = "${data.template_file.virtual_machine_network_content.*.rendered[count.index]}"
}


// ignition_config creates the CoreOS Ignition config for use on the virtual machines.
data "ignition_config" "ignition_config" {
  count    = "${ var.count }"
  networkd = ["${data.ignition_networkd_unit.virtual_machine_network_unit.*.id[count.index]}"]
}

// convert cloud_init to ignition config
data "ct_config" "master" {
  count        = "${ var.count }"
  content      = "${ element(split("`",  var.cloud_init), count.index) }"
  platform     = "custom"
  pretty_print = false
}
