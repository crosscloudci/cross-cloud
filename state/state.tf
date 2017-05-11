provider "aws" { }

resource "aws_s3_bucket" "cncf" {
  bucket = "${ var.name }"
  acl    = "private"

  region = "${ var.aws_region }"

  versioning {
    enabled = true
  }
}



