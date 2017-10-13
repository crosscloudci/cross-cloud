# Enable the GZIP Provider
provider "gzip" {
  compressionlevel = "BestCompression"
}

resource "random_id" "cncf" {
  byte_length = 8
}

provider "openstack" {
  auth_url    = "${ var.os_auth_url }"
  region      = "${ var.os_region_name }"
  domain_name = "${ var.os_user_domain_name }"
  user_name   = "${ var.os_auth_url }"
  tenant_name = "${ var.os_tenant_name }"
  password    = "${ var.os_password }"
}
