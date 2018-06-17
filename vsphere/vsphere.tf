# The vSphere Provider must be configured through
# environment variables.
#
# The required set for this project is
#
# VSPHERE_SERVER
# VSPHERE_USER
# VSPHERE_PASSWORD

provider "vsphere" {
  vsphere_server = "${var.vsphere_server}"
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"

  allow_unverified_ssl = true
}

# Enable the GZIP Provider
provider "gzip" {
  compressionlevel = "BestCompression"
}

data "template_file" "cloud_conf" {
  template = "${file( "${ path.module}/cloud.conf" )}"

  vars {
    vsphere_user       = "${var.vsphere_user}"
    vsphere_server     = "${var.vsphere_server}"
    vsphere_password   = "${var.vsphere_password}"
    vsphere_datacenter = "${var.datacenter}"
    vsphere_datastore  = "${var.datastore_name}"
    vsphere_vm_folder  = "${var.vm_folder}"
  }
}
