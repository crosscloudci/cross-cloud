# provider "etcdiscovery" {
# }

# resource "etcdiscovery_token" "etcd" {
#   size = "${ var.master_node_count }"
# }

# output "etcd_discovery" {
#   value = "${ etcdiscovery_token.etcd.id }"
# }

# resource "etcdiscovery_token" "etcd_events" {
#   size = "${ var.master_node_count }"
# }

# output "etcd_discovery_events" {
#   value = "${ etcdiscovery_token.etcd_events.id }"
# }
