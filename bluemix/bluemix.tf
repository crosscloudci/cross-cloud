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

data "ibm_network_vlan" "vlan_public" {
  name = "public"
}

data "ibm_network_vlan" "vlan_private" {
  name = "private"
}

resource "ibm_container_cluster" "testacc_cluster" {
  name            = "${ var.name }"
  datacenter      = "${ var.zone }"
  machine_type    = "${ var.type }"
  isolation       = "${ var.isolation }"
  public_vlan_id  = "${ data.ibm_network_vlan.vlan_public.id }"
  private_vlan_id = "${ data.ibm_network_vlan.vlan_private.id }"
  no_subnet       = false
  # subnet_id       = ["1154643"]
  wait_time_minutes = 10
  workers = [{
    name = "worker1"
    action = "add"
  },
  {
    name = "worker2"
    action = "add"
  },
  {
    name = "worker3"
    action = "add"
  },
]

  org_guid     = "${ data.ibm_org.orgdata.id }"
  space_guid   = "${ var.name }"
  account_guid = "${ data.ibm_account.accountData.id }"
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = "${ibm_container_cluster.testacc_cluster.name}"
  org_guid        = "${data.ibm_org.orgdata.id}"
  space_guid      = "${ibm_space.space.id}"
  account_guid    = "${data.ibm_account.accountData.id}"
}

resource "null_resource" "kubeconfig" {

  provisioner "local-exec" {
    command = <<LOCAL_EXEC
cat "${ data.ibm_container_cluster_config.cluster_config.config_file_path }" > "${ var.data_dir}/kubeconifg"
LOCAL_EXEC
  }

