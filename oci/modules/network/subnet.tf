resource "oci_core_subnet" "K8sSubnetAD1" {
  count               = "1"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block          = "${lookup(var.network_cidrs, "kubeSubnetAD1")}"
  display_name        = "${var.label_prefix}K8sSubnetAD1"
  compartment_id      = "${var.compartment_id}"
  vcn_id              = "${oci_core_virtual_network.cross-cloud-vcn.id}"
  route_table_id      = "${oci_core_route_table.public-route-table.id}"
  security_list_ids   = ["${list(oci_core_security_list.K8sSubnetSecurityList.id)}"]
  dhcp_options_id     = "${oci_core_virtual_network.cross-cloud-vcn.default_dhcp_options_id}"
}

resource "oci_core_subnet" "K8sSubnetAD2" {
  count               = "1"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  cidr_block          = "${lookup(var.network_cidrs, "kubeSubnetAD2")}"
  display_name        = "${var.label_prefix}K8sSubnetAD2"
  compartment_id      = "${var.compartment_id}"
  vcn_id              = "${oci_core_virtual_network.cross-cloud-vcn.id}"
  route_table_id      = "${oci_core_route_table.public-route-table.id}"
  security_list_ids   = ["${list(oci_core_security_list.K8sSubnetSecurityList.id)}"]
  dhcp_options_id     = "${oci_core_virtual_network.cross-cloud-vcn.default_dhcp_options_id}"
}

resource "oci_core_subnet" "LbSubnetAD1" {
  count               = "1"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block          = "${lookup(var.network_cidrs, "LbSubnetAD1")}"
  display_name        = "${var.label_prefix}LbSubnetAD1"
  compartment_id      = "${var.compartment_id}"
  vcn_id              = "${oci_core_virtual_network.cross-cloud-vcn.id}"
  route_table_id      = "${oci_core_route_table.public-route-table.id}"
  security_list_ids   = ["${list(oci_core_security_list.LbSubnetSecurityList.id)}"]
  dhcp_options_id     = "${oci_core_virtual_network.cross-cloud-vcn.default_dhcp_options_id}"
}

resource "oci_core_subnet" "LbSubnetAD2" {
  count               = "1"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  cidr_block          = "${lookup(var.network_cidrs, "LbSubnetAD2")}"
  display_name        = "${var.label_prefix}LbSubntAD2"
  compartment_id      = "${var.compartment_id}"
  vcn_id              = "${oci_core_virtual_network.cross-cloud-vcn.id}"
  route_table_id      = "${oci_core_route_table.public-route-table.id}"
  security_list_ids   = ["${list(oci_core_security_list.LbSubnetSecurityList.id)}"]
  dhcp_options_id     = "${oci_core_virtual_network.cross-cloud-vcn.default_dhcp_options_id}"
}
