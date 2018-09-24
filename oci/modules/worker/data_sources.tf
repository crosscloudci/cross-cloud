resource "gzip_me" "cloud_init" {
    count  = "${var.count}"
    input  = "${element(split("`", var.worker_cloud_init), count.index)}"
}

data "template_file" "ign" {
  count    = "${var.count}"
  template = "${file("${path.module}/../../ignition.json")}"

  vars {
    hostname      = "${ var.hostname }-${count.index + 1}.${var.hostname_suffix}"
    hostname_path = "${var.hostname_path}"
    cloud_config  = "${ element(gzip_me.cloud_init.*.output, count.index) }"
  }
}