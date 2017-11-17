#!/bin/bash
docker run \
  -v /tmp/data:/cncf/data \
  -e TF_VAR_os_auth_url=$OS_AUTH_URL \
  -e TF_VAR_os_region_name=$OS_REGION_NAME \
  -e TF_VAR_os_user_domain_name=$OS_USER_DOMAIN_NAME \
  -e TF_VAR_os_username=$OS_USERNAME \
  -e TF_VAR_os_project_name=$OS_PROJECT_NAME \
  -e TF_VAR_os_password=$OS_PASSWORD \
  -e CLOUD=openstack \
  -e COMMAND=destroy \
  -e NAME=cross-cloud \
  -e BACKEND=file \
  -ti provisioning
