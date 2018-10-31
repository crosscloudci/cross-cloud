resource "oci_identity_compartment" "cross-cloud-compartment" {
  name                            = "${var.label_prefix}-compartment"
  description                     = "compartment for ${var.label_prefix}"
  compartment_id                  = "${var.compartment_id}"
}