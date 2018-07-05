resource "vsphere_virtual_machine" "worker" {
  count = "${ var.count }"
  name  = "${ var.name }-worker-${ count.index + 1 }"

  resource_pool_id     = "${ var.resource_pool }"
  datastore_id         = "${data.vsphere_datastore.datastore.id}"
  folder               = "${var.folder_path}"
  guest_id             = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type            = "${data.vsphere_virtual_machine.template.scsi_type}"
  num_cpus             = "${var.num_cpu}"
  num_cores_per_socket = "${var.num_cores_per_socket}"
  memory               = "${var.memory}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }

  vapp {
    properties {
      "guestinfo.hostname"                    = "${var.name}-worker-${count.index + 1}"
      "guestinfo.coreos.config.data"          = "${base64encode(element(data.template_file.ign.*.rendered, count.index))}"
      "guestinfo.coreos.config.data.encoding" = "base64"
    }
  }
}
