#!/bin/bash
# Remove the Liquid Glass Omarchy theme and switch back to a stock theme.
# curl -fsSL https://raw.githubusercontent.com/FarzadHayat/omarchy-liquid-glass-theme/main/uninstall.sh | bash

set -euo pipefail

SRC="$HOME/.local/share/omarchy-liquid-glass-theme"
LINK="$HOME/.config/omarchy/themes/liquid-glass"
FALLBACK="${1:-tokyo-night}"

current=$(cat "$HOME/.local/state/omarchy/current/theme.name" 2>/dev/null || true)
if [[ $current == "liquid-glass" ]]; then
  omarchy theme set "$FALLBACK"
fi

[[ -L $LINK ]] && rm "$LINK"
rm -rf "$SRC"
echo "Liquid Glass removed."
