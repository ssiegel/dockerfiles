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
        iptables \
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
    rm -rf "$GOPATH"

ADD update-iptables.tmpl /opt/docker-gen/

ADD supervisord.conf /etc/supervisor/conf.d/
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD []
# docker run -d -it --privileged --net host --name iptables -v /var/run/docker.sock:/var/run/docker.sock localhost/iptables
