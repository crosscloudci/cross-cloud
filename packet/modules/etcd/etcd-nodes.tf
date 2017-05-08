resource "packet_device" "masters" {
  hostname         = "master${ count.index + 1 }.${ var.internal_tld }"
  count            = "${ var.master_node_count }"
  facility         = "${ var.packet_facility }"
  project_id       = "${ var.packet_project_id }"
  plan             = "${ var.packet_master_device_plan }"
  billing_cycle    = "${ var.packet_billing_cycle }"
  operating_system = "${ var.packet_operating_system }"
  user_data        = "${ element(data.template_file.etcd_user_data.*.rendered, count.index) }"
}
