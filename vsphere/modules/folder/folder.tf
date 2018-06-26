resource "vsphere_folder" "xcloud" {
  path          = "${var.folder_path}"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}
