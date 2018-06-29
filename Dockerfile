FROM crosscloudci/debian-go:latest
MAINTAINER "Denver Williams <denver@debian.nz>"
ENV KUBECTL_VERSION=v1.8.1
ENV HELM_VERSION=v2.7.2
#PIN to Commit on Master
ENV TERRAFORM_VERSION=0.11.7
# ENV TERRAFORM_VERSION=master
# ENV TF_DEV=true
# ENV TF_RELEASE=true
ENV ARC=amd64

RUN apt update && apt install -y unzip git bash util-linux wget tar curl jq less

#Install Gcloud
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-stretch main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
apt-get update && \
apt-get -y install google-cloud-sdk

#Install Kubectl
RUN wget -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/$ARC/kubectl && \
chmod +x /usr/local/bin/kubectl

#Install helm
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz  && \
tar xvzf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
mv linux-amd64/helm /usr/local/bin && \
rm -rf helm-*gz linux-amd64

# # Install Terraform 
# WORKDIR $GOPATH/src/github.com/hashicorp/terraform
# RUN git clone https://github.com/dlx/terraform.git ./ && \
#     git checkout ${TERRAFORM_VERSION} && \
#     /bin/bash scripts/build.sh
# WORKDIR $GOPATH


#Install Terraform from Upstream
RUN wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_"${TERRAFORM_VERSION}"_linux_$ARC.zip
RUN unzip terraform*.zip -d /usr/bin


# Install Bluemix Provider
RUN mkdir -p $GOPATH/src/github.com/terraform-providers \
&& cd $GOPATH/src/github.com/terraform-providers \
&& git clone https://github.com/IBM-Bluemix/terraform-provider-ibm.git \
&& cd $GOPATH/src/github.com/terraform-providers/terraform-provider-ibm \
&& make build

# Install Gzip+base64, ETCD, ibm, and oci Provider
RUN go get -u github.com/jakexks/terraform-provider-gzip && \
    go get -u github.com/paperg/terraform-provider-etcdiscovery && \
    go get -u github.com/oracle/terraform-provider-oci && \
  echo providers { >> ~/.terraformrc && \
  echo '    gzip = "/go/bin/terraform-provider-gzip"' >> ~/.terraformrc && \
  echo '    etcdiscovery = "/go/bin/terraform-provider-etcdiscovery"' >> ~/.terraformrc && \
  echo '    ibm = "/go/bin/terraform-provider-ibm"' >> ~/.terraformrc && \
  echo '    oci = "/go/bin/terraform-provider-oci"' >> ~/.terraformrc && \
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

ENTRYPOINT ["/cncf/provision.sh"]
