#!/bin/bash
set -e

# Run conformance test
# export KUBECONFIG=/cncf/data/aws-mvci-stable/kubeconfig
export KUBERNETES_CONFORMANCE_TEST=y
export KUBERNETES_PROVIDER=skeleton

# Run all conformance tests
cd $GOPATH/src/k8s.io/kubernetes
go run hack/e2e.go -v --test --test_args="--ginkgo.focus=\[Conformance\]"

# Run all parallel-safe conformance tests in parallel
GINKGO_PARALLEL=y go run hack/e2e.go -v --test --test_args="--ginkgo.focus=\[Conformance\] --ginkgo.skip=\[Serial\]"

# ... and finish up with remaining tests in serial
go run hack/e2e.go -v --test --test_args="--ginkgo.focus=\[Serial\].*\[Conformance\]"
