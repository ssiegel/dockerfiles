FROM ssiegel/base-nginx
MAINTAINER Stefan Siegel <ssiegel@sdas.net>

RUN set -ex; \
    DOCKER_GEN_VERSION=0.3.9; \
    curl -L https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
        | tar -C /usr/bin -xvz docker-gen

ADD nginx /etc/nginx/
ADD docker-gen.service /etc/systemd/system/

RUN set -ex; \
    rm /etc/nginx/conf.d/10-realip.conf; \
    systemctl enable docker-gen.service

EXPOSE 80 443
