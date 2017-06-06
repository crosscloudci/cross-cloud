provider "google" {}

terraform {
  backend "s3" {
    bucket = "aws"
    key    = "setme"
    region = "ap-southeast-2"
  }
}
