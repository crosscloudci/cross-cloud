#!/usr/bin/env bash

set -e

URL_TO_BINARY="https://github.com/vmware/govmomi/releases/download/v0.18.0/govc_darwin_amd64.gz"
curl -L $URL_TO_BINARY | gunzip > /usr/local/bin/govc
chmod +x /usr/local/bin/govc

TEMPLATE_URL="https://stable.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova.ova"
TEMPLATE_DC="$(grep -A1 "datacenter" "../input.tf" | tail -n 1 | awk '{print $3}' | tr -d \'\"\' )"
TEMPLATE_DS="$(grep -A1 "datastore_name" "../input.tf" | tail -n 1 | awk '{print $3}' | tr -d \'\"\' )"
TEMPLATE_POOL="$(grep -A1 "resource_pool" "../input.tf" | tail -n 1 | awk '{print $3}' | tr -d \'\"\' )"
TEMPLATE_NAME="$(grep -A1 "master_template_name" "../input.tf" | tail -n 1 | awk '{print $3}' | tr -d \'\"\' )"

EXISTING_TEMPLATE="$(govc find -type m -name "${TEMPLATE_NAME}" | head -n 1)"
if [ -n "${EXISTING_TEMPLATE}" ]; then
  govc object.rename "${EXISTING_TEMPLATE}" "${TEMPLATE_NAME}_archived_$(date +%s)"
fi

govc import.ova -dc="${TEMPLATE_DC}" -ds="${TEMPLATE_DS}" -pool="${TEMPLATE_POOL}" -name="${TEMPLATE_NAME}" "${TEMPLATE_URL}"
govc vm.upgrade -vm="${TEMPLATE_NAME}"
govc snapshot.create -dc="${TEMPLATE_DC}" -vm="${TEMPLATE_NAME}" clone-root
govc vm.markastemplate -dc="${TEMPLATE_DC}" "${TEMPLATE_NAME}"
