FROM buildpack-deps:jessie-curl

COPY ./entrypoint.sh /seed/entrypoint.sh
COPY ./bash.template /seed/bash.template

RUN chmod +x /seed/entrypoint.sh

WORKDIR /seed

ENTRYPOINT ["/seed/entrypoint.sh"]
