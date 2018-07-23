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

data "template_file" "ign" {
  count    = "${var.count}"
  template = "${file("${path.module}/../../ignition.json")}"

  vars {
    hostname      = "${var.name}-worker-${count.index + 1}.${var.hostname_suffix}"
    hostname_path = "${var.hostname_path}"
    cloud_config  = "${base64encode(element(split("`", var.cloud_init), count.index))}"
  }
}
