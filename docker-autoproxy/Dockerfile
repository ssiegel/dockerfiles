FROM debian:jessie
MAINTAINER Stefan Siegel <ssiegel@sdas.net>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://cdn.debian.net/debian jessie main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://cdn.debian.net/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://cdn.debian.net/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure tzdata && \
    echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections && \
    echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections && \
    apt-get update && apt-get upgrade -y && apt-get install -y locales

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential mercurial git golang-go \
        nginx-light \
        supervisor

RUN export GOPATH=/root/go && \
    go get -v github.com/tools/godep && \
    go get -v -d github.com/jwilder/docker-gen && \
    cd "$GOPATH/src/github.com/jwilder/docker-gen" && \
    git checkout tags/0.3.3 && \
    "$GOPATH/bin/godep" restore && \
    make && \
    install -m 0755 -D docker-gen /opt/docker-gen/docker-gen && \
    cd /opt/docker-gen/ && \
    rm -rf "$GOPATH" && \
    rm -f /etc/nginx/sites-*/default && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

ADD nginx.tmpl /opt/docker-gen/
ADD error.html /usr/share/nginx/html/

RUN set -ex; \
    cd /usr/share/nginx/html; \
    sed 's/{{NUM}}/500/g;s/{{NAME}}/Internal Server Error/g;s/{{TEXT}}/&nbsp;/g'; \
    sed 's/{{NUM}}/502/g;s/{{NAME}}/Bad Gateway/g;s/{{TEXT}}/&nbsp;/g'; \
    sed 's/{{NUM}}/503/g;s/{{NAME}}/Service Temporarily Unavailable/g;s/{{TEXT}}/&nbsp;/g'; \
    sed 's/{{NUM}}/504/g;s/{{NAME}}/Gateway Time-out/g;s/{{TEXT}}/&nbsp;/g'; \
    sed 's/{{NUM}}/403/g;s/{{NAME}}/Forbidden/g;s/{{TEXT}}/&nbsp;/g'; \
    sed 's/{{NUM}}/404/g;s/{{NAME}}/Not Found/g;s/{{TEXT}}/&nbsp;/g'; \
    rm error.html

ADD supervisord.conf /etc/supervisor/conf.d/
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD []
EXPOSE 80
# docker run -d -t --name autoproxy -e ICC_OVERRIDE=1 -e SNAT={{IP1}} -p {{IP1}}:80:80 -p {{IP2}}:80:80 -v /var/run/docker.sock:/var/run/docker.sock localhost/autoproxy
