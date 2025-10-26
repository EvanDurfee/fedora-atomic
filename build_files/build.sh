#!/bin/bash

set -ouex pipefail

# Copy System Files onto root
rsync -rvK /ctx/sys_files/ /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
added_packages=(
	# Userspace sensor support
	lm_sensors
	# Virtualization and multi-arch distrobox support
	qemu
	qemu-user-static
	gnome-boxes
	# Shell and system tools
	git-credential-libsecret
	wl-clipboard
	zsh
	tmux
	distrobox
	ripgrep
	fd-find
	bat
	git-delta
	fzf
	btop
	fastfetch
	wireguard-tools
	micro
	rclone
	restic
	syncthing
	# Gaming
	steam-devices
	mozilla-openh264
	# Shell extension
	gnome-shell-extension-user-theme
	gnome-shell-extension-caffeine
	gnome-shell-extension-launch-new-instance
	gnome-shell-extension-appindicator
	gnome-shell-extension-just-perfection
	gnome-shell-extension-blur-my-shell
)

removed_packages=(
	# Fedora bookmarks and web stuff
	fedora-bookmarks
	fedora-chromium-config
	fedora-chromium-config-gnome
	fedora-flathub-remote  # Fedora filtered flathub (we'll use normal flathub)
	fedora-workstation-repositories  # Fedora selected 3rd party repos (we'll use rpmfusion instead)
	# Extensions
#	gnome-shell-extension-apps-menu
#	gnome-shell-extension-places-menu
#	gnome-shell-extension-window-list
#	gnome-shell-extension-background-logo
	# Replace system monitor with MissionCenter
	gnome-system-monitor
	# Replace gnome extensions with extension manager flatpak
	gnome-extensions-app
	# Remove intro tour
	gnome-tour
	# Remove basic help app
	yelp
	# Remove htop (added by ublue) in favor of btop
	htop
)


dnf5 install -y "${added_packages[@]}"
dnf5 rm -y "${removed_packages[@]}"

just --justfile=/ctx/distrobox-auto/justfile install
just --justfile=/ctx/flatpak-sync/justfile install

# Install brew via the ublue copr
dnf5 -y copr enable ublue-os/packages
dnf5 install -y ublue-brew
dnf5 -y copr disable ublue-os/staging


#### Example for enabling a System Unit File

# systemctl enable podman.socket
