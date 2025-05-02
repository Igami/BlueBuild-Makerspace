#!/bin/bash

EXT_DIR="/usr/share/inkscape/extensions"
INKSTITCH_URL=$(curl -s https://api.github.com/repos/inkstitch/inkstitch/releases/latest | jq -r '.assets[] | select(.name | test("linux.*\\.tar\\.xz$")) | .browser_download_url')

mkdir -p "$EXT_DIR"
wget -qO- "$INKSTITCH_URL" | tar -xJ -C "$EXT_DIR"

flatpak override org.inkscape.Inkscape --filesystem="$EXT_DIR":ro
