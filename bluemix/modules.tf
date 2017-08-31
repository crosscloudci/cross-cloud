# module "vpc" {
#   source = "./modules/vpc"
#   name = "${ var.name }"
#   cidr = "${ var.cidr }"
#   region = "${ var.region }"
# }

# module "cluster" {
#   source = "./modules/cluster"
#   name = "${ var.name }"
#   region = "${ var.region }"
#   zone = "${ var.zone }"
#   project = "${ var.project}"
#   node_count = "${ var.node_count }"
#   network = "${ var.name }"
#   subnetwork = "${ var.name }"
#   node_version = "${ var.node_version }"
#   master_user = "${ var.master_user }"
#   master_password = "${ var.master_password }"
#   vm_size = "${ var.vm_size }"
#   node_pool_count = "${ var.node_pool_count }"
#   data_dir = "${ var.data_dir }"
# }

# module "kubeconfig" {
#   source = "../kubeconfig"

#   ca = "${base64decode(module.cluster.ca)}"
#   client = "${base64decode(module.cluster.client)}"
#   client_key = "${base64decode(module.cluster.client_key)}"
#   endpoint = "${ module.cluster.endpoint }"
#   data_dir = "${ var.data_dir }"
#   name = "gke_${ var.project }_${ var.zone }-a_${ var.name }"
# }
