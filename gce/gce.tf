# Configure the Microsoft Azure Provider
provider "google" {
  #credentials = "${file("gce.json")}"
  project     = "${ var.project }"
  region      = "${ var.region }"
}

terraform {
  backend "s3" {
    bucket = "aws"
    key    = "aws"
    region = "ap-southeast-2"
  }
}
