# The OpenStack Provider must be configured through
# environment variables.
#
# The required set for this project is
#
# OS_AUTH_URL
# OS_REGION_NAME
# OS_USER_DOMAIN_NAME
# OS_USERNAME
# OS_PROJECT_NAME
# OS_PASSWORD

provider "openstack" {
  auth_url = "${ var.os_auth_url }"
  region = "${ var.os_region_name }"
  domain_name = "${ var.os_user_domain_name }"
  user_name = "${ var.os_username }"
  tenant_name = "${ var.os_project_name }"
  password = "${ var.os_password }"
}

# Enable the GZIP Provider
provider "gzip" {
  compressionlevel = "BestCompression"
}

# OpenStack cloud.json file
resource "gzip_me" "cloud_config_file" {
  input = "${ data.template_file.cloud_conf.rendered }"
}

data "template_file" "cloud_conf" {
  template = "${ file( "${ path.module }/cloud.conf" )}"
  vars {
    os_username = "${ var.os_username }"
    os_region_name = "${ var.os_region_name }"
    os_password = "${ var.os_password }"
    os_auth_url = "${ var.os_auth_url }"
    os_project_name = "${ var.os_project_name }"
    os_user_domain_name = "${ var.os_user_domain_name }"
  }
}
