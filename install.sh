#!/bin/bash
# Install the Liquid Glass Omarchy theme.
# curl -fsSL https://raw.githubusercontent.com/FarzadHayat/omarchy-liquid-glass-theme/main/install.sh | bash
#
# `omarchy theme install` would drop this theme's hyprland.lua and terminal
# configs (Omarchy only trusts colors and images from a cloned repo), which is
# where the blur, rounding, rim and see-through terminals live. So the repo is
# cloned outside the themes folder and linked in, which Omarchy treats as yours.

set -euo pipefail

REPO="https://github.com/FarzadHayat/omarchy-liquid-glass-theme.git"
SRC="$HOME/.local/share/omarchy-liquid-glass-theme"
LINK="$HOME/.config/omarchy/themes/liquid-glass"

command -v omarchy >/dev/null || { echo "Omarchy not found. This theme is for Omarchy (omarchy.org)." >&2; exit 1; }

if [[ -d $SRC/.git ]]; then
  git -C "$SRC" pull --ff-only --quiet
else
  rm -rf "$SRC"
  git clone --quiet --depth 1 "$REPO" "$SRC"
fi

mkdir -p "$(dirname "$LINK")"
if [[ -e $LINK && ! -L $LINK ]]; then
  rm -rf "$LINK"
fi
ln -sfn "$SRC" "$LINK"

omarchy theme set liquid-glass
echo "Liquid Glass installed. Uninstall: curl -fsSL https://raw.githubusercontent.com/FarzadHayat/omarchy-liquid-glass-theme/main/uninstall.sh | bash"
