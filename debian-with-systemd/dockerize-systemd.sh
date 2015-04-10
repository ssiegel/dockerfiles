#!/bin/sh

set -ex

if [ "$container" != "docker" ]; then
  echo '$container must be set to "docker" for this script (and systemd) to work' >&2
  exit 1
fi

# loop over services that are not useful in a docker container and mask them
(
  echo local-fs.target
  echo swap.target
  find /lib/systemd/system/multi-user.target.wants/ \
       /lib/systemd/system/sockets.target.wants/ \
       /lib/systemd/system/sysinit.target.wants/ \
       -type l -printf "%P\n"
) | sort -u | grep -Ev \
      `# but keep some of them:` \
      `# we want journald` \
    -e '^systemd-journald' \
      `# tmpfiles-setup to set up e.g. /var correctly` \
    -e '^systemd-tmpfiles-setup\.service$' \
      `# systemd-update-utmp is needed, cf. http://lists.freedesktop.org/archives/systemd-devel/2015-February/027952.html` \
      `# http://anonscm.debian.org/cgit/pkg-systemd/systemd.git/commit/debian/rules?id=8341218591c79b4fcfd2542b765b605faff8690b` \
      `# https://bugzilla.redhat.com/show_bug.cgi?id=1002806` \
    -e '^systemd-update-utmp' \
      `# this will be mounted anyway, so just keep it` \
    -e '^dev-mqueue\.mount$' \
      `# mask the remaining ones` \
  | while read unit; do
    ln -s /dev/null /etc/systemd/system/$unit
  done

# Disable preset services
mkdir -p /etc/systemd/system-preset
cat > /etc/systemd/system-preset/50-docker-disable-all.preset <<EOT
enable multi-user.target
disable *
EOT

systemctl set-default multi-user.target
systemctl preset-all

# Add a simple root shell, can be used with e.g. docker run -it <image> --unit=shell.service
mkdir -p /etc/systemd/system
cat > /etc/systemd/system/shell.service <<EOT
[Unit]
Description=Simple Root Shell

[Service]
Restart=always
ExecStart=-/bin/login -f root
Type=idle
StandardInput=tty-force
StandardOutput=inherit
StandardError=inherit
KillMode=process
IgnoreSIGPIPE=no
SendSIGHUP=yes
EOT
