resource "oci_core_instance" "K8sMaster" {
  count               = "${var.count}"
  availability_domain = "${var.availability_domain}"
  compartment_id      = "${var.compartment_id}"
  display_name        = "${var.label_prefix}${var.display_name_prefix}-${count.index}"
  shape               = "${var.shape}"
  subnet_id           = "${var.subnet_id}"

  source_details      {
    source_type = "image"
    source_id = "${var.coreos_image_ocid}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    # user_data = "${ base64encode(element(split("`", var.master_cloud_init), count.index)) }"
    user_data = "${ base64encode(element(data.template_file.ign.*.rendered, count.index)) }"
  }

  timeouts {
    create = "60m"
  }

  # provisioner "remote-exec" {
  #   connection{
  #     type = "ssh"
  #     user = "core"
  #     private_key = "${var.ssh_private_key}"
  #     host = "${self.public_ip}"
  #   }
  #   inline = [
  #     "wget http://169.254.169.254/opc/v1/instance/metadata/user_data",
  #     "base64 -d user_data > user_data_decoded",
  #     "sudo coreos-cloudinit --from-file user_data_decoded"
  #   ]
  # }
}