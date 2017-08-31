FROM golang:alpine
MAINTAINER "Denver Williams <denver@ii.coop>"
ENV KUBECTL_VERSION=v1.6.6
ENV HELM_VERSION=v2.4.1
ENV GCLOUD_VERSION=150.0.0
ENV AWSCLI_VERSION=1.11.75
ENV AZURECLI_VERSION=2.0.2
ENV PACKETCLI_VERSION=1.33
#PIN to Commit on Master
ENV TERRAFORM_VERSION=master
ENV TF_DEV=true
ENV TF_RELEASE=true
ENV ARC=amd64


# Install AWS / AZURE CLI Deps
RUN apk update
RUN apk add --update git bash util-linux wget tar curl build-base jq \
  py-pip groff less openssh bind-tools python python-dev libffi-dev openssl-dev

# no way to pin this packet-cli at the moment
# RUN go get -u github.com/ebsarr/packet
RUN pip install packet-python==${PACKETCLI_VERSION} argh tabulate
RUN pip install azure-cli==${AZURECLI_VERSION}
RUN pip install awscli==${AWSCLI_VERSION}

RUN apk --purge -v del py-pip && \
	rm /var/cache/apk/*

# Install Google Cloud SDK
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86.tar.gz && \
tar xvfz google-cloud-sdk-${GCLOUD_VERSION}-linux-x86.tar.gz && \
./google-cloud-sdk/install.sh -q


#Install Kubectl
RUN wget -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/$ARC/kubectl && \
chmod +x /usr/local/bin/kubectl

#Install helm
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz  && \
tar xvzf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
mv linux-amd64/helm /usr/local/bin && \
rm -rf helm-*gz linux-amd64

# Install Terraform
WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/dlx/terraform.git ./ && \
    git checkout ${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh
WORKDIR $GOPATH

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
COPY gce/ /cncf/gce/
COPY gke/ /cncf/gke/
COPY packet/ /cncf/packet/
COPY bluemix/ /cncf/bluemix/
COPY cross-cloud/ /cncf/cross-cloud/
COPY kubeconfig/ /cncf/kubeconfig/
COPY tls/ /cncf/tls/
COPY provision.sh /cncf/
COPY s3-backend.tf /cncf
COPY file-backend.tf /cncf
RUN chmod +x /cncf/provision.sh
#ENTRYPOINT ["/cncf/provision.sh"]
WORKDIR /cncf/
#CMD ["/cncf/provision.sh"]
CMD ["bash", "-c", "/cncf/provision.sh ${CLOUD}-${COMMAND} ${NAME} ${BACKEND}"]
