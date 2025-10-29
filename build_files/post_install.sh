#!/bin/bash

set -ouex pipefail

# Bluefin update timer
if test -e /usr/lib/systemd/system/uupd.timer; then
    systemctl enable uupd.timer
else
    systemctl enable rpm-ostreed-automatic.timer
    systemctl enable flatpak-system-update.timer
    systemctl --global enable flatpak-user-update.timer
fi


# Enable system flatpak installs
systemctl enable flatpak-installation-sync.service
systemctl --global enable flatpak-installation-sync.service

# Enable Update Timers
systemctl --global enable distrobox-auto-pull.timer
systemctl --global enable distrobox-auto-assemble.service

