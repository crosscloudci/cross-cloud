FROM golang:alpine
MAINTAINER "Denver Williams <denver@ii.coop>"
ENV KUBECTL_VERSION=v1.5.2
ENV ARC=amd64

# Install AWS / AZURE CLI Deps
RUN apk update
RUN apk add --update git bash wget curl

#Install Kubectl
RUN wget -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/$ARC/kubectl && \
chmod +x /usr/local/bin/kubectl


COPY $(pwd)/data /Data

CMD ["/bin/bash"]