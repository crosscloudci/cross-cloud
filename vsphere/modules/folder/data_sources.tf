// datacenter looks up the datacenter where all resources will be placed.
data "vsphere_datacenter" "datacenter" {
  name = "${var.datacenter}"
}
