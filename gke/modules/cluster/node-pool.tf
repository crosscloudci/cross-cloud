resource "google_container_node_pool" "cncf" {
  name               = "${ var.name }"
  project            = "${ var.project }"
  zone               = "${ var.zone }"
  cluster            = "${google_container_cluster.cncf.name}"
  initial_node_count = "${ var.node_pool_count }"
}
