# Build the Go binaries using a multi-stage build phase named "golang"
FROM golang:1.10.3-alpine3.7 as golang
LABEL maintainer="Andrew Kutz <akutz@vmware.com>"

RUN apk --no-cache add git
# Build the IBM Bluemix Terraform provider
RUN git clone https://github.com/IBM-Cloud/terraform-provider-ibm.git \
    $GOPATH/src/github.com/IBM-Cloud/terraform-provider-ibm && \
    go install github.com/IBM-Cloud/terraform-provider-ibm

# Build Oracle terraform provider
RUN git clone https://github.com/terraform-providers/terraform-provider-oci.git \
    $GOPATH/src/github.com/terraform-providers/terraform-provider-oci && \
    cd $GOPATH/src/github.com/terraform-providers/terraform-provider-oci ; git checkout tags/v3.0.0 ; cd - && \ 
    go install github.com/terraform-providers/terraform-provider-oci

# Build the Packet.net terraform provider
RUN git clone https://github.com/terraform-providers/terraform-provider-packet.git \
    $GOPATH/src/github.com/terraform-providers/terraform-provider-packet && \
    cd $GOPATH/src/github.com/terraform-providers/terraform-provider-packet && \
    go install github.com/terraform-providers/terraform-provider-packet

# Build the Gzip+Base64 Terraform provider Gzip+base64 & ETCD Provider
RUN go get github.com/jakexks/terraform-provider-gzip

# Build the Etcd Terraform provider
RUN go get github.com/paperg/terraform-provider-etcdiscovery

# Build the vSphere CLI tool, govc.
ENV GOVC_VERSION=0.18.0
RUN go get -d github.com/vmware/govmomi && \
    git --work-tree /go/src/github.com/vmware/govmomi \
        --git-dir /go/src/github.com/vmware/govmomi/.git \
        checkout -b v${GOVC_VERSION} v${GOVC_VERSION} && \
    go install github.com/vmware/govmomi/govc


#FROM crosscloudci/debian-go:latest
FROM alpine:3.7
LABEL maintainer="Denver Williams <denver@debian.nz>"
ENV KUBECTL_VERSION=v1.13.0
ENV HELM_VERSION=v2.13.1
# PIN to Commit on Master
ENV TERRAFORM_VERSION=0.11.7
# ENV TERRAFORM_VERSION=master
# ENV TF_DEV=true
# ENV TF_RELEASE=true
ENV ARC=amd64

# Install the common dependencies.
RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    git \
    jq \
    less \
    libc6-compat \
    openssh-client \
    tar \
    unzip \
    util-linux

# Install the dependencies for rvm.
RUN apk --no-cache add \
    gcc \
    gnupg \
    libssl1.0 \
    linux-headers \
    make \
    musl-dev \
    openssl \
    openssl-dev \
    procps \
    ruby \
    zlib \
    zlib-dev

# Install pip, used to install the AWS CLI.
RUN apk --no-cache add \
    py2-pip

# Install the dependencies for the Google Cloud SDK.
RUN apk --no-cache add \
    python \
    py-crcmod

# Link lib64 to lib
RUN ln -s /lib /lib64

# Remove the package cache to free space.
RUN rm -fr /var/cache/apk/*

# Upgrade pip and install the AWS CLI.
RUN pip install --upgrade pip && pip install awscli

# Copy the GoVC binary from the golang build stage.
COPY --from=golang /go/bin/govc /usr/local/bin/

# Install the Google Cloud SDK
ENV CLOUD_SDK_VERSION=203.0.0
ENV PATH=/google-cloud-sdk/bin:$PATH
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
  echo '    oci = "/usr/local/bin/terraform-provider-oci"' >> ~/.terraformrc && \
  echo '    packet = "/usr/local/bin/terraform-provider-packet"' >> ~/.terraformrc && \
  echo } >> ~/.terraformrc


#Add Terraform Modules
COPY validate-cluster/ /cncf/validate-cluster/

COPY aws/ /cncf/aws/
COPY azure/ /cncf/azure/
COPY ibm/ /cncf/ibm/
COPY gce/ /cncf/gce/
COPY gke/ /cncf/gke/
COPY openstack/ /cncf/openstack/
COPY oci/ /cncf/oci/
COPY packet/ /cncf/packet/
COPY vsphere/ /cncf/vsphere/
# END PROVIDERS - DO NOT REPLACE

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
COPY addons-arm/ /cncf/addons-arm/

COPY master_templates-v1.7.2/ /cncf/master_templates-v1.7.2/
COPY master_templates-v1.8.1/ /cncf/master_templates-v1.8.1/
COPY master_templates-v1.9.0-alpha.1/ /cncf/master_templates-v1.9.0-alpha.1/
COPY master_templates-v1.9.0/ /cncf/master_templates-v1.9.0/
COPY master_templates-v1.9.0-dns-etcd/ /cncf/master_templates-v1.9.0-dns-etcd/
COPY master_templates-v1.10.0/ /cncf/master_templates-v1.10.0/
COPY master_templates-v1.10.0-ubuntu/ /cncf/master_templates-v1.10.0-ubuntu/
COPY master_templates-v1.13.0/ /cncf/master_templates-v1.13.0/
COPY master_templates-v1.13.0-ubuntu/ /cncf/master_templates-v1.13.0-ubuntu/

COPY worker_templates-v1.7.2/ /cncf/worker_templates-v1.7.2/
COPY worker_templates-v1.8.1/ /cncf/worker_templates-v1.8.1/
COPY worker_templates-v1.9.0-alpha.1/ /cncf/worker_templates-v1.9.0-alpha.1/
COPY worker_templates-v1.9.0/ /cncf/worker_templates-v1.9.0/
COPY worker_templates-v1.10.0/ /cncf/worker_templates-v1.10.0/
COPY worker_templates-v1.10.0-ubuntu/ /cncf/worker_templates-v1.10.0-ubuntu/
COPY worker_templates-v1.13.0/ /cncf/worker_templates-v1.13.0/
COPY worker_templates-v1.13.0-ubuntu/ /cncf/worker_templates-v1.13.0-ubuntu/

# Ensure scripts are executable.
RUN chmod +x /cncf/provision.sh \
             /cncf/vsphere/destroy-force.sh

WORKDIR /cncf/

CMD ["bash", "-c", "/cncf/provision.sh"]
