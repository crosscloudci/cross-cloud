resource "packet_device" "workers" {
  hostname         = "worker${ count.index + 1 }.${ var.internal_tld }"
  count            = "${ var.worker_node_count }"
  facility         = "${ var.packet_facility }"
  project_id       = "${ var.packet_project_id }"
  plan             = "${ var.packet_worker_device_plan }"
  billing_cycle    = "${ var.packet_billing_cycle }"
  operating_system = "${ var.packet_operating_system }"
  user_data        = "${ element(data.template_file.worker_user_data.*.rendered, count.index) }"
}
