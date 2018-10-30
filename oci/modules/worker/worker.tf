resource "oci_core_instance" "K8sWorker" {
  count               = "${var.count}"
  availability_domain = "${var.availability_domain}"
  compartment_id      = "${var.compartment_id}"
  display_name        = "${ var.hostname }-${ count.index + 1 }.${ var.hostname_suffix }"
  shape               = "${var.shape}"
  subnet_id           = "${var.subnet_id}"

  source_details      {
    source_type = "image"
    source_id = "${var.coreos_image_ocid}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${ base64encode(element(data.template_file.ign.*.rendered, count.index)) }"
  }

  timeouts {
    create = "60m"
  }
}
