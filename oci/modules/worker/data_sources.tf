resource "gzip_me" "cloud_init" {
    count  = "${var.count}"
    input  = "${element(split("`", var.worker_cloud_init), count.index)}"
}

data "template_file" "ign" {
  count    = "${var.count}"
  template = "${file("${path.module}/../../ignition.json")}"

  vars {
    hostname      = ""
    hostname_path = "/etc/ignore_hostname"
    cloud_config  = "${ element(gzip_me.cloud_init.*.output, count.index) }"
  }
}