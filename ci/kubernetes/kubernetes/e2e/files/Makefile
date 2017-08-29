KUBERNETES_VERSION=v1.6.3
GOOS=$(shell go env GOOS)
GOPATH=$(shell go env GOPATH)
KUBERNETES_SRC=$(GOPATH)/src/k8s.io/kubernetes

build-conformance: kubernetes build-tests kubectl ginkgo 

kubernetes:
	git clone https://github.com/kubernetes/kubernetes
	mkdir -p $(GOPATH)/src/k8s.io
	mv kubernetes $(KUBERNETES_SRC)
	cd $(KUBERNETES_SRC) && git checkout $(KUBERNETES_VERSION)

build-tests:
	cd $(KUBERNETES_SRC) && make WHAT=test/e2e/e2e.test

kubectl:
	cd $(KUBERNETES_SRC) && make WHAT=cmd/kubectl

ginkgo:
	go get github.com/onsi/ginkgo/ginkgo
	mkdir -p $(KUBERNETES_SRC)/_output/bin
	cp $(shell go env GOPATH)/bin/ginkgo $(KUBERNETES_SRC)/_output/bin/ginkgo

