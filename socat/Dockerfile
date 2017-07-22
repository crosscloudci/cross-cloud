FROM debian:jessie

# Install build tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -yy && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yy \
        automake            \
        build-essential     \
        curl                \
        git                 \
        pkg-config

RUN mkdir /build
RUN mkdir /output

ADD . /build

RUN chmod +x /build/build.sh
RUN /build/build.sh

CMD ["/bin/bash"]
