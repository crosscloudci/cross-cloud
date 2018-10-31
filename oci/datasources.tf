data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.oci_tenancy_ocid}"
}