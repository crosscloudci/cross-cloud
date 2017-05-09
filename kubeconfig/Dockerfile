FROM golang:alpine
MAINTAINER "Denver Williams <denver@ii.coop>"
ENV KUBECTL_VERSION=v1.5.2


#Install Kubectl
RUN wget -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/$ARC/kubectl && \
chmod +x /usr/local/bin/kubectl


COPY ./data /Data

CMD ["/bin/bash"]