module "master" {
  source = "./modules/master"

  name = "${ var.name }"
  master_flavor_name = "${ var.flavor_name }"
  master_image_name = "${ var.image_name }"
  master_count = "${ var.master_count }"
}

