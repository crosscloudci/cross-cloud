#!/bin/sh

# posix complaint
# verified by https://www.shellcheck.net

# The script requires exactly one argument -- the name of the environment
# to remove.
if [ -z "${1}" ]; then
  echo "usage: ${0} NAME"
  exit 1
fi

# The name of the environment to deploy.
NAME="${1}"

exec docker run \
  --rm \
  --dns 147.75.69.23 --dns 8.8.8.8 \
  -v "$(pwd)/data:/cncf/data" \
  -e VSPHERE_SERVER="${VSPHERE_SERVER}" \
  -e VSPHERE_USER="${VSPHERE_USER}" \
  -e VSPHERE_PASSWORD="${VSPHERE_PASSWORD}" \
  -e VSPHERE_AWS_ACCESS_KEY_ID="${VSPHERE_AWS_ACCESS_KEY_ID}" \
  -e VSPHERE_AWS_SECRET_ACCESS_KEY="${VSPHERE_AWS_SECRET_ACCESS_KEY}" \
  -e VSPHERE_AWS_REGION="${VSPHERE_AWS_REGION}" \
  -e CLOUD=vsphere \
  -e COMMAND=deploy \
  -e NAME="${NAME}" \
  -e BACKEND=file \
  -ti provisioning