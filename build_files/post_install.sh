#!/bin/bash

set -ouex pipefail

# Enable system flatpak installs
systemctl enable flatpak-installation-sync.service
systemctl --global enable flatpak-installation-sync.service

# Enable Update Timers
systemctl --global enable distrobox-auto-pull.timer
systemctl --global enable distrobox-auto-assemble.service
