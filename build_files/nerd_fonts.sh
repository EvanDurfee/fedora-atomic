#!/bin/bash

set -ouex pipefail

latest_release="$(git ls-remote --tags https://github.com/ryanoasis/nerd-fonts \
	| cut -f 2 \
	| grep -P '^refs/tags/v([0-9]+\.){2}[0-9]+$' \
	| sed 's|refs/tags/||' \
	| sort --version-sort \
	| tail -n 1 \
)"

# font_dir="~/.local/share/fonts"
font_dir="/usr/share/fonts"

download_font() {
	font_family="$1"
	shift
	font_names=("$@")
	font_name_args=()
	for font_name in "${font_names[@]}"; do
		font_name_args+=(--wildcards)
		font_name_args+=("$font_name-*")
	done

	mkdir -p "$font_dir"/"$font_family"
	curl -L --fail-with-body https://github.com/ryanoasis/nerd-fonts/releases/download/"$latest_release"/"$font_family".tar.xz -o - \
		| tar -xJf - -C "$font_dir"/"$font_family" "${font_name_args[@]}"
}

# Download fonts
download_font FiraCode FiraCodeNerdFont FiraCodeNerdFontMono
# Meslo LGM = medium line spacing, LGMDZ = dotted zero
download_font Meslo MesloLGMNerdFont MesloLGMNerdFontMono

fc-cache --force --verbose
