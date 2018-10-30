#!/bin/sh

exec docker run \
  --rm \
  --dns 147.75.69.23 --dns 8.8.8.8 \
  -v "$(pwd)/data:/cncf/data" \
  -e KUBECONFIG=/cncf/data/kubeconfig \
  -ti provisioning \
  kubectl "${@}"