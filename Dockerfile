FROM crosscloudci/debian-go:latest
MAINTAINER "Denver Williams <denver@debian.nz>"
ENV KUBECTL_VERSION=v1.8.1
ENV HELM_VERSION=v2.7.2
#PIN to Commit on Master
ENV TERRAFORM_VERSION=0.10.6
# ENV TERRAFORM_VERSION=master
# ENV TF_DEV=true
# ENV TF_RELEASE=true
ENV ARC=amd64


# Install AWS / AZURE CLI Deps
RUN apt update
RUN apt install -y unzip git bash util-linux wget tar curl awscli python-pip jq \
  groff-base less libffi-dev

#Install Kubectl
RUN wget -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/$ARC/kubectl && \
chmod +x /usr/local/bin/kubectl

#Install helm
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz  && \
tar xvzf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
mv linux-amd64/helm /usr/local/bin && \
rm -rf helm-*gz linux-amd64

#Install Terraform from Upstream
RUN wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_"${TERRAFORM_VERSION}"_linux_$ARC.zip
RUN unzip terraform*.zip -d /usr/bin


# # Install Terraform 
# WORKDIR $GOPATH/src/github.com/hashicorp/terraform
# RUN git clone https://github.com/dlx/terraform.git ./ && \
#     git checkout ${TERRAFORM_VERSION} && \
#     /bin/bash scripts/build.sh
# WORKDIR $GOPATH

# Install Bluemix Provider
RUN mkdir -p $GOPATH/src/github.com/terraform-providers \
&& cd $GOPATH/src/github.com/terraform-providers \
&& git clone https://github.com/IBM-Bluemix/terraform-provider-ibm.git \
&& cd $GOPATH/src/github.com/terraform-providers/terraform-provider-ibm \
&& make build

# Install Gzip+base64 & ETCD Provider
RUN go get -u github.com/jakexks/terraform-provider-gzip && \
    go get -u github.com/paperg/terraform-provider-etcdiscovery && \
  echo providers { >> ~/.terraformrc && \
  echo '    gzip = "/go/bin/terraform-provider-gzip"' >> ~/.terraformrc && \
  echo '    etcdiscovery = "/go/bin/terraform-provider-etcdiscovery"' >> ~/.terraformrc && \
  echo } >> ~/.terraformrc

#Add Terraform Modules

COPY aws/ /cncf/aws/
COPY azure/ /cncf/azure/
COPY bluemix/ /cncf/bluemix/
COPY gce/ /cncf/gce/
COPY gke/ /cncf/gke/
COPY openstack/ /cncf/openstack/
COPY packet/ /cncf/packet/

COPY bootstrap/ /cncf/bootstrap/
COPY dns/ /cncf/dns/

COPY kubeconfig/ /cncf/kubeconfig/
COPY socat/ /cncf/socat/
COPY tls/ /cncf/tls/

COPY provision.sh /cncf/
COPY s3-backend.tf /cncf/
COPY file-backend.tf /cncf/

COPY master_templates-v1.7.2/ /cncf/master_templates-v1.7.2/
COPY master_templates-v1.8.1/ /cncf/master_templates-v1.8.1/
COPY master_templates-v1.9.0-alpha.1/ /cncf/master_templates-v1.9.0-alpha.1/

COPY worker_templates-v1.7.2/ /cncf/worker_templates-v1.7.2/
COPY worker_templates-v1.8.1/ /cncf/worker_templates-v1.8.1/
COPY worker_templates-v1.9.0-alpha.1/ /cncf/worker_templates-v1.9.0-alpha.1/

RUN chmod +x /cncf/provision.sh
WORKDIR /cncf/

CMD ["bash", "-c", "/cncf/provision.sh ${CLOUD}-${COMMAND} ${NAME} ${BACKEND} ${DATA}"]
