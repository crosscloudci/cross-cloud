terraform {
  backend "local" {
    path = "/cncf/data/terraform.tfstate"
  }
}