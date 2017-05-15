provider "aws" { }
provider "gzip" {compressionlevel = "BestCompression"}

# configured via:
# $ export AWS_ACCESS_KEY_ID="anaccesskey"
# $ export AWS_SECRET_ACCESS_KEY="asecretkey"
# $ export AWS_DEFAULT_REGION="us-west-2"
# https://www.terraform.io/docs/providers/aws/#environment-variables

# terraform {
#   backend "s3" {
#     bucket = "aws"
#     key    = "/cncf/data/aws"
#     region = "ap-southeast-2"
#   }
# }
