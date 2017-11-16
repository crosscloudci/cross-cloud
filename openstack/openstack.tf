# The OpenStack Provider must be configured through
# environment variables.
#
# One preferred set is:
#
# OS_AUTH_URL
# OS_REGION_NAME
# OS_USER_DOMAIN_NAME
# OS_USERNAME
# OS_TENANT_NAME or OS_TENANT_ID
# OS_PASSWORD

provider "openstack" {
}

# Enable the GZIP Provider
provider "gzip" {
  compressionlevel = "BestCompression"
}
