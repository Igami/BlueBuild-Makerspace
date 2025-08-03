#!/bin/bash

EXTENSIONS_DIR="/usr/share/inkscape/extensions"
FLATPAK_OVERRIDES_DIR="/etc/flatpak/overrides"
INKSTITCH_URL=$(curl -s https://api.github.com/repos/inkstitch/inkstitch/releases/latest | jq -r '.assets[] | select(.name | test("linux-x86_64\\.tar\\.xz$")) | .browser_download_url')

# Create extensions directory and install Inkstitch
mkdir -p "$EXTENSIONS_DIR"
wget -qO- "$INKSTITCH_URL" | tar -xJ -C "$EXTENSIONS_DIR"

# Create system-wide Flatpak override for Inkscape
mkdir -p "$FLATPAK_OVERRIDES_DIR"
cat > "$FLATPAK_OVERRIDES_DIR/org.inkscape.Inkscape" << EOF
[Context]
filesystems=$EXTENSIONS_DIR:ro
EOF

echo "Inkstitch installed and Flatpak override configured for Inkscape"
