resource "template_dir" "create" {
  source_dir      = "${path.module}/templates/create"
  destination_dir = "/cncf/data/addons/create"

  vars {
    oci_region              = "${var.oci_region}"
    oci_tenancy_ocid        = "${var.oci_tenancy_ocid}"
    oci_user_ocid           = "${var.oci_user_ocid}"
    oci_fingerprint         = "${var.oci_fingerprint}"
    oci_compartment_ocid    = "${var.oci_compartment_ocid}"
    oci_vcn_ocid            = "${var.oci_vcn_ocid}"
    oci_lb_subnet_1_ocid    = "${var.oci_lb_subnet_1_ocid}"
    oci_lb_subnet_2_ocid    = "${var.oci_lb_subnet_2_ocid}"
    oci_sl_mgmt_mode        = "${var.oci_sl_mgmt_mode}"

  }
}

resource "template_dir" "apply" {
  source_dir      = "${path.module}/templates/apply"
  destination_dir = "/cncf/data/addons/apply"

  vars {

  }
}
