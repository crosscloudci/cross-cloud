provider "etcdiscovery" {
}

resource "etcdiscovery_token" "etcd" {
  size = "${ var.master_node_count }"
}

output "etcd_discovery" {
  value = "${ etcdiscovery_token.etcd.id }"
}

