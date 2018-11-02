resource "packet_device" "workers" {
  hostname         = "${ var.hostname }-${ count.index + 1 }.${ var.hostname_suffix }"
  count            = "${ var.worker_node_count }"
  facility         = "${ var.packet_facility }"
  project_id       = "${ var.packet_project_id }"
  plan             = "${ var.packet_worker_device_plan }"
  billing_cycle    = "${ var.packet_billing_cycle }"
  operating_system = "${ var.packet_operating_system }"
  user_data = "${ element(split("`", var.worker_cloud_init), count.index) }"
}
