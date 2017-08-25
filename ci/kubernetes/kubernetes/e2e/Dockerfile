FROM golang:1.7
MAINTAINER "Denver Williams <denver@ii.coop>"

# Install Deps
RUN apt-get update \
&& apt-get install -y rsync


# Copy Files
COPY files/ /kubernetes/e2e/

WORKDIR /kubernetes/e2e

RUN make build-conformance

CMD ["/bin/bash"]
