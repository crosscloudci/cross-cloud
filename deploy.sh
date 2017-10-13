#!/bin/bash
docker run \
  -v /tmp/data:/cncf/data \
  -e OS_AUTH_URL=$OS_AUTH_URL \
  -e OS_REGION_NAME=$OS_REGION_NAME \
  -e OS_USER_DOMAIN_NAME=$OS_USER_DOMAIN_NAME \
  -e OS_USERNAME=$OS_USERNAME \
  -e OS_TENANT_NAME=$OS_TENANT_NAME \
  -e OS_PASSWORD=$OS_PASSWORD \
  -e CLOUD=openstack \
  -e COMMAND=deploy \
  -e NAME=cross-cloud \
  -e BACKEND=file \
  -ti provisioning
