FROM luzifer/vault:latest

USER root

RUN set -ex \
 && apk --no-cache add \
      bash \
      curl \
      jq

COPY entrypoint.sh /usr/local/bin/

USER vault

VOLUME ["/config"]
ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
