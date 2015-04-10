FROM debian:jessie
MAINTAINER Stefan Siegel <ssiegel@sdas.net>

ENV container=docker \
    HOME=/root \
    DEBIAN_FRONTEND=noninteractive

RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/docker-apt-get-defaults && \
    echo 'APT::Install-Recommends "false";' >> /etc/apt/apt.conf.d/docker-apt-get-defaults && \
    echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/docker-apt-get-defaults && \
    \
    echo "deb http://cdn.debian.net/debian jessie main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://cdn.debian.net/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://cdn.debian.net/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list && \
    \
    apt-get update && \
    apt-get upgrade && \
    \
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure tzdata && \
    \
    echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections && \
    echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections && \
    apt-get install locales

RUN `# loop over services that are not useful in a docker container`; \
    (find /lib/systemd/system/multi-user.target.wants/ \
          /lib/systemd/system/sockets.target.wants/ \
          /lib/systemd/system/sysinit.target.wants/ \
          -type l -printf "%P\n"; \
          echo local-fs.target; \
          echo swap.target) \
          | sort -u | grep -Ev \
    `# but keep some of them` \
              `# we want journald` \
          -e '^systemd-journald' \
              `# e.g. /var needs to be set up correctly` \
          -e '^systemd-tmpfiles-setup\.service$' \
              `# systemd-update-utmp is needed, cf. http://lists.freedesktop.org/archives/systemd-devel/2015-February/027952.html` \
              `# http://anonscm.debian.org/cgit/pkg-systemd/systemd.git/commit/debian/rules?id=8341218591c79b4fcfd2542b765b605faff8690b` \
              `# https://bugzilla.redhat.com/show_bug.cgi?id=1002806` \
          -e '^systemd-update-utmp' \
              `# this will be mounted anyway, so just keep it` \
          -e '^dev-mqueue\.mount$' \
    `# mask the remaining ones` \
          | while read unit; do ln -s /dev/null /etc/systemd/system/$unit; done && \
    \
    mkdir /etc/systemd/system-preset && \
    echo 'enable multi-user.target' > /etc/systemd/system-preset/50-docker-disable-all.preset && \
    echo 'disable *' >> /etc/systemd/system-preset/50-docker-disable-all.preset && \
    systemctl set-default multi-user.target && \
    systemctl preset-all

# Add a simple root shell, can be used with e.g. docker run -it <image> --unit=shell.service
ADD shell.service /etc/systemd/system/

ENTRYPOINT ["/bin/systemd"]
CMD []

ONBUILD RUN apt-get update
