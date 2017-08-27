provider "ibm" {}

resource "ibm_space" "space" {
  name        = "${ var.name }"
  org         = "${ var.org }"
}

data "ibm_org" "orgdata" {
  org = "${var.org}"
}

data "ibm_account" "accountData" {
  org_guid = "${data.ibm_org.orgdata.id}"
}
