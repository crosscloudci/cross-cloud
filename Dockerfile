FROM golang:alpine
MAINTAINER "Denver Williams <denver@ii.coop>"
ENV KUBECTL_VERSION=v1.5.2
ENV HELM_VERSION=v2.4.1
ENV GCLOUD_VERSION=150.0.0
ENV AWSCLI_VERSION=1.11.75
ENV AZURECLI_VERSION=2.0.2
ENV PACKETCLI_VERSION=1.33
ENV TERRAFORM_VERSION=0.9.4
ENV ARC=amd64

# Install AWS / AZURE CLI Deps
RUN apk update
RUN apk add --update git bash util-linux wget tar curl build-base jq \
  py-pip groff less openssh bind-tools python python-dev libffi-dev openssl-dev

# no way to pin this packet-cli at the moment
RUN go get -u github.com/ebsarr/packet
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
RUN wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_"${TERRAFORM_VERSION}"_linux_$ARC.zip
RUN unzip terraform*.zip -d /usr/bin

# Install CFSSL
RUN go get -u github.com/cloudflare/cfssl/cmd/cfssl && \
go get -u github.com/cloudflare/cfssl/cmd/...

# Install Gzip+base64 Provider
RUN go get -u github.com/jakexks/terraform-provider-gzip && \
  echo providers { >> ~/.terraformrc && \
  echo '    gzip = "terraform-provider-gzip"' >> ~/.terraformrc && \
  echo } >> ~/.terraformrc

#Add Terraform Modules

COPY provision.sh /cncf/
RUN chmod +x /cncf/provision.sh
#ENTRYPOINT ["/cncf/provision.sh"]
WORKDIR /cncf/
#CMD ["aws-deploy"]
