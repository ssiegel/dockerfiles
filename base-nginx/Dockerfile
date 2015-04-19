FROM ssiegel/base-debian-systemd
MAINTAINER Stefan Siegel <ssiegel@sdas.net>

RUN set -ex; \
    echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" > /etc/apt/sources.list.d/nginx.list; \
    apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
    apt-get update; \
    apt-get install curl ca-certificates nginx; \
    rm -rf /etc/nginx/conf.d

ADD nginx /etc/nginx/
ADD nginx.service /etc/systemd/system/

RUN set -ex; \
    systemctl enable nginx.service; \
    echo 'fastcgi_param  PATH_TRANSLATED    $document_root$fastcgi_script_name;' >> /etc/nginx/fastcgi_params; \
    /etc/nginx/generate-error-pages.sh /usr/share/nginx/html > /etc/nginx/error_pages

ONBUILD RUN apt-get update
