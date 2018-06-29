#!/bin/sh

docker run \
  --rm \
  --dns 147.75.69.23 --dns 8.8.8.8 \
  -v $(pwd)/data:/cncf/data \
  -v $(pwd)/keys:/cncf/keys \
  -e CLOUD=oci \
  -e COMMAND=destroy \
  -e NAME=${1:-$(whoami)} \
  -e BACKEND=file \
  -ti ccloud:v0.1


  -e OCI_TENANCY_OCID=$OCI_TENANCY_OCID \
  -e OCI_USER_OCID=$OCI_USER_OCID \
  -e OCI_FINGERPRINT=$OCI_FINGERPRINT \
  -e OCI_PRIVATE_KEY_PATH=$OCI_PRIVATE_KEY_PATH \
  -e OCI_REGION=$OCI_REGION \