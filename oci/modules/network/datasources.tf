# List of ADs
data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_id}"
}
