provider "google" {}

terraform {
  backend "s3" {
    bucket = "aws"
    key    = "aws"
    region = "ap-southeast-2"
  }
}