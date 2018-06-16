module "folder" {
  source = "./modules/folder"

  datacenter  = "${var.datacenter}"
  folder_path = "Workloads/CNCF Cross-Cloud/${var.name}"
}
