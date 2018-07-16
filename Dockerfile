# Build the Go binaries using a multi-stage build phase named "golang"
FROM golang:1.10.3-alpine3.7 as golang
LABEL maintainer="Andrew Kutz <akutz@vmware.com>"

RUN apk --no-cache add git

# Build the IBM Bluemix Terraform provider
RUN git clone https://github.com/IBM-Bluemix/terraform-provider-ibm.git \
    $GOPATH/src/github.com/terraform-providers/terraform-provider-ibm && \
    go install github.com/terraform-providers/terraform-provider-ibm

# Build the Gzip+Base64 Terraform provider Gzip+base64 & ETCD Provider
RUN go get github.com/jakexks/terraform-provider-gzip

# Build the Etcd Terraform provider
RUN go get github.com/paperg/terraform-provider-etcdiscovery

ENV GOVC_VERSION=0.18.0
RUN go get -d github.com/vmware/govmomi && \
    git --work-tree /go/src/github.com/vmware/govmomi \
        --git-dir /go/src/github.com/vmware/govmomi/.git \
        checkout -b v${GOVC_VERSION} v${GOVC_VERSION} && \
    go install github.com/vmware/govmomi/govc

#FROM crosscloudci/debian-go:latest
FROM alpine:3.7
LABEL maintainer="Denver Williams <denver@debian.nz>"
ENV KUBECTL_VERSION=v1.8.1
ENV HELM_VERSION=v2.9.1
# PIN to Commit on Master
ENV TERRAFORM_VERSION=0.11.7
# ENV TERRAFORM_VERSION=master
# ENV TF_DEV=true
# ENV TF_RELEASE=true
ENV ARC=amd64

# Install some common dependencies
RUN apk --no-cache add \
    unzip git bash util-linux curl tar jq less libc6-compat openssh-client

# Link lib64 to lib
RUN ln -s /lib /lib64

# Install rvm deps
RUN apk --no-cache add \
    gcc gnupg curl ruby bash procps musl-dev make linux-headers \
        zlib zlib-dev openssl openssl-dev libssl1.0

# Install the Google Cloud SDK
ENV CLOUD_SDK_VERSION=203.0.0
ENV PATH=/google-cloud-sdk/bin:$PATH
RUN apk --no-cache add python py-crcmod
RUN curl -sSL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz | \
    tar xz -C /

# Install the kubectl binary
RUN curl -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${ARC}/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install the helm binary
RUN curl -sSL https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-${ARC}.tar.gz | \
    tar xz --strip-components=1 -C /usr/local/bin linux-${ARC}/helm

# Install the terraform binary
RUN curl -sSLO https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_"${TERRAFORM_VERSION}"_linux_$ARC.zip && \
    unzip terraform_"${TERRAFORM_VERSION}"_linux_${ARC}.zip -d /usr/bin

# Copy the Terraform providers from the golang build stage
COPY --from=golang /go/bin/terraform-provider-* /usr/local/bin/

# Write the configuration file Terraform uses to query available providers
# and their binaries
RUN echo providers { >> ~/.terraformrc && \
  echo '    gzip = "/usr/local/bin/terraform-provider-gzip"' >> ~/.terraformrc && \
  echo '    etcdiscovery = "/usr/local/bin/terraform-provider-etcdiscovery"' >> ~/.terraformrc && \
  echo '    ibm = "/usr/local/bin/terraform-provider-ibm"' >> ~/.terraformrc && \
  echo } >> ~/.terraformrc


#Add Terraform Modules
COPY validate-cluster/ /cncf/validate-cluster/

COPY aws/ /cncf/aws/
COPY azure/ /cncf/azure/
COPY ibm/ /cncf/ibm/
COPY gce/ /cncf/gce/
COPY gke/ /cncf/gke/
COPY openstack/ /cncf/openstack/
COPY packet/ /cncf/packet/
COPY vsphere/ /cncf/vsphere/

COPY bootstrap/ /cncf/bootstrap/
COPY dns/ /cncf/dns/
COPY dns-etcd/ /cncf/dns-etcd/

COPY kubeconfig/ /cncf/kubeconfig/
COPY socat/ /cncf/socat/
COPY tls/ /cncf/tls/

COPY provision.sh /cncf/
COPY s3-backend.tf /cncf/
COPY file-backend.tf /cncf/

COPY rbac/ /cncf/rbac/
COPY addons/ /cncf/addons/

COPY master_templates-v1.7.2/ /cncf/master_templates-v1.7.2/
COPY master_templates-v1.8.1/ /cncf/master_templates-v1.8.1/
COPY master_templates-v1.9.0-alpha.1/ /cncf/master_templates-v1.9.0-alpha.1/
COPY master_templates-v1.9.0/ /cncf/master_templates-v1.9.0/
COPY master_templates-v1.9.0-dns-etcd/ /cncf/master_templates-v1.9.0-dns-etcd/
COPY master_templates-v1.10.0/ /cncf/master_templates-v1.10.0/

COPY worker_templates-v1.7.2/ /cncf/worker_templates-v1.7.2/
COPY worker_templates-v1.8.1/ /cncf/worker_templates-v1.8.1/
COPY worker_templates-v1.9.0-alpha.1/ /cncf/worker_templates-v1.9.0-alpha.1/
COPY worker_templates-v1.9.0/ /cncf/worker_templates-v1.9.0/
COPY worker_templates-v1.10.0/ /cncf/worker_templates-v1.10.0/

RUN chmod +x /cncf/provision.sh
WORKDIR /cncf/

CMD ["bash", "-c", "/cncf/provision.sh"]
