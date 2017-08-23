FROM buildpack-deps:jessie
MAINTAINER "Denver Williams <denver@ii.coop>"

ENV DNSPERF_VER="2.1.0.0"
# Install Deps

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    dnsutils libbind-dev libkrb5-dev \
    libssl-dev libcap-dev libxml2-dev \
    bind9utils build-essential wget && \
    wget ftp://ftp.nominum.com/pub/nominum/dnsperf/$DNSPERF_VER/dnsperf-src-$DNSPERF_VER-1.tar.gz && \
    wget ftp://ftp.nominum.com/pub/nominum/dnsperf/data/queryfile-example-current.gz && \
    gunzip queryfile-example-current.gz && \
    tar zxvf dnsperf-src-$DNSPERF_VER-1.tar.gz && \
    rm dnsperf-src-$DNSPERF_VER-1.tar.gz && \
    cd dnsperf-src-$DNSPERF_VER-1 && \
    ./configure && \
    make && \
    make install && \
    apt-get purge -y libbind-dev libkrb5-dev \
    libssl-dev libcap-dev libxml2-dev \
    build-essential && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /dnsperf-src-$DNSPERF_VER-1

WORKDIR /coredns

RUN for i in `seq 1 20000`; do echo "$i.example.org A" >> /coredns/dns.txt ;done;

CMD ["/bin/bash"]
