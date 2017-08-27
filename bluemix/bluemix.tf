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

resource "ibm_container_cluster" "testacc_cluster" {
  name            = "test"
  datacenter      = "dal10"
  machine_type    = "free"
  isolation       = "public"
  public_vlan_id  = "vlan"
  private_vlan_id = "vlan"
  # subnet_id       = ["1154643"]

  workers = [{
    name = "worker1"

    action = "add"
  }]

  org_guid     = "${ data.ibm_org.orgdata.id }"
  space_guid   = "${ var.name }"
  account_guid = "${ data.ibm_account.accountData.id }"
}
