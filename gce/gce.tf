# Configure the Microsoft Azure Provider
provider "google" {
  #credentials = "${file("gce.json")}"
  project     = "${ var.project }"
  region      = "${ var.region }"
}

provider "dnsimple" {
}


