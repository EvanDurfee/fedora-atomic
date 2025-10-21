#!/bin/bash

set -ouex pipefail

source /etc/os-release

IMPORTANT_PACKAGES=(
    systemd
    pipewire
    wireplumber
)

case "${VARIANT_ID:-}" in
"silverblue")
    IMPORTANT_PACKAGES+=(
        gdm
        mutter
        gnome-session
        gnome-software
        nautilus
    )
    ;;
"kinoite")
    IMPORTANT_PACKAGES+=(
        kwin
        plasma-desktop
        sddm
        plasma-discover
    )
    ;;
*) ;;
esac

for package in "${IMPORTANT_PACKAGES[@]}"; do
    rpm -q "$package" >/dev/null || { echo "Missing package: $package... Exiting"; exit 1 ; }
done
