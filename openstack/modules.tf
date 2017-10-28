module "network" {
  source = "./modules/network"

  public_network = "${ var.public_network }"
}

module "master" {
  source = "./modules/master"

  name = "${ var.name }"
  master_flavor_name = "${ var.master_flavor_name }"
  master_image_name = "${ var.master_image_name }"
  master_count = "${ var.master_count }"

  private_network_id = "${ module.network.private_network_id }"

}

module "node" {
  source = "./modules/node"

  name = "${ var.name }"
  node_flavor_name = "${ var.node_flavor_name }"
  node_image_name = "${ var.node_image_name }"
  node_count = "${ var.node_count }"
  
  private_network_id = "${ module.network.private_network_id }"
}
