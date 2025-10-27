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
	adw-gtk3-theme  # gtk3 port of the gtk4 libadwaita theme
	gnome-tweaks
	# Userspace sensor support
	lm_sensors
	# Container and virtualization tools
	qemu  # Virtualization
	qemu-user-static # Usermode emulation support (also usable for running containers from other architectures)
	qemu-user-binfmt
	gnome-boxes
	incus  #LXC successor for VM and container management
	# docker is handled separately from copr
	podman
	podman-compose
	podman-machine
	distrobox
	# critical system tools
	git
	git-subtree
	git-credential-libsecret
	wl-clipboard
	just
	zsh
	fish

	fastfetch
	wireguard-tools

#	tmux
#	ripgrep
#	fd-find
#	bat
#	git-delta
#	fzf
#	btop
#	micro
#	p7zip
#	p7zip-plugins

#	rclone
#	restic
#	syncthing


	# Devices
	steam-devices
	# Codecs
	# ublue base handles all the futzing about with rpmfusion for us
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
	gnome-shell-extension-background-logo
	# Replace system monitor with MissionCenter
	gnome-system-monitor
	# Replace gnome extensions with extension manager flatpak
	gnome-extensions-app
	# Remove intro tour
	gnome-tour
	# Remove basic help app
	yelp
	# Remove htop (added by ublue)
	htop
)

dnf5 install -y "${added_packages[@]}"
dnf5 rm -y "${removed_packages[@]}"

# Docker setup take from ublue dx
dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/docker-ce.repo
dnf5 -y install --enablerepo=docker-ce-stable \
	containerd.io \
	docker-buildx-plugin \
	docker-ce \
	docker-ce-cli \
	docker-compose-plugin \
	docker-model-plugin

# Install brew via the ublue copr
dnf5 -y copr enable ublue-os/packages
dnf5 install -y ublue-brew
dnf5 -y copr disable ublue-os/packages

just --justfile=/ctx/distro-utils/distrobox-auto/justfile install
just --justfile=/ctx/distro-utils/flatpak-sync/justfile install
cp /ctx/distro-utils/jetbrains-installer/jetbrains-ide-setup.sh /usr/bin/jetrbains-ide-setup
/ctx/distro-utils/nerd-font-install.sh FiraCode Meslo  # TODO: swap to brew fonts?

#### Example for enabling a System Unit File

# systemctl enable podman.socket
