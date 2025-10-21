#!/bin/bash

set -ouex pipefail

# Enable system flatpak installs
systemctl enable flatpak-sync-install.service

# Enable Update Timers
systemctl --global enable distrobox-auto-pull.timer
systemctl --global enable distrobox-auto-assemble.service
