FROM ssiegel/debian-with-systemd
MAINTAINER Stefan Siegel <ssiegel@sdas.net>

RUN set -ex; \
    echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" > /etc/apt/sources.list.d/nginx.list; \
    apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
    apt-get update; \
    apt-get install curl ca-certificates nginx; \
    \
    DOCKER_GEN_VERSION=0.3.9; \
    curl -L https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
        | tar -C /usr/bin -xvz docker-gen

ADD nginx.conf /etc/nginx/
ADD nginx-http.tmpl /etc/nginx/
ADD error.html /usr/share/nginx/html/
ADD docker-gen.service /etc/systemd/system/

RUN set -ex; \
    cd /usr/share/nginx/html; \
    sed 's/{{NUM}}/500/g;s/{{NAME}}/Internal Server Error/g;s/{{TEXT}}/&nbsp;/g'; \
    sed 's/{{NUM}}/502/g;s/{{NAME}}/Bad Gateway/g;s/{{TEXT}}/&nbsp;/g'; \
    sed 's/{{NUM}}/503/g;s/{{NAME}}/Service Temporarily Unavailable/g;s/{{TEXT}}/&nbsp;/g'; \
    sed 's/{{NUM}}/504/g;s/{{NAME}}/Gateway Time-out/g;s/{{TEXT}}/&nbsp;/g'; \
    sed 's/{{NUM}}/403/g;s/{{NAME}}/Forbidden/g;s/{{TEXT}}/&nbsp;/g'; \
    sed 's/{{NUM}}/404/g;s/{{NAME}}/Not Found/g;s/{{TEXT}}/&nbsp;/g'; \
    rm error.html; \
    \
    systemctl enable docker-gen.service

ENTRYPOINT ["/bin/systemd"]
CMD []
EXPOSE 80 443
# docker run -d -t --name autoproxy -e ICC_OVERRIDE=1 -e SNAT={{IP1}} -p {{IP1}}:80:80 -p {{IP2}}:80:80 -v /var/run/docker.sock:/var/run/docker.sock localhost/autoproxy
