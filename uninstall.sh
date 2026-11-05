#!/bin/bash
# Remove the Liquid Glass Omarchy theme and its island bar, and switch back to a
# stock theme and the stock bar.
# curl -fsSL https://raw.githubusercontent.com/FarzadHayat/omarchy-liquid-glass-theme/main/uninstall.sh | bash
#
# Pass a theme name to switch to something other than Tokyo Night:
# curl -fsSL .../uninstall.sh | bash -s -- catppuccin

set -euo pipefail

REPO_PATH="FarzadHayat/omarchy-liquid-glass-theme"
SRC="$HOME/.local/share/omarchy-liquid-glass-theme"
LINK="$HOME/.config/omarchy/themes/liquid-glass"
PLUGINS="$HOME/.config/omarchy/plugins"
HOOKS="$HOME/.config/omarchy/hooks"
FALLBACK="${1:-tokyo-night}"

# 1. Switch away from the theme first.
current=$(cat "$HOME/.local/state/omarchy/current/theme.name" 2>/dev/null || true)
if [[ $current == "liquid-glass" ]]; then
  omarchy theme set "$FALLBACK"
fi

# 2. Island bar: removing it brings back the stock bar.
if [[ -d $PLUGINS/liquid-glass.bar ]]; then
  omarchy plugin remove liquid-glass.bar --yes >/dev/null
fi
rm -rf "$PLUGINS"/.liquid-glass.bar.bak.*
rm -f "$HOOKS/post-update.d/liquid-glass-bar" "$HOOKS/post-boot.d/liquid-glass-bar"

# 3. The theme itself: the link from the one-line install, or a copy from
# `omarchy theme install` (only when it really is this repo).
if [[ -L $LINK ]]; then
  rm "$LINK"
elif [[ -d $LINK/.git ]] && git -C "$LINK" remote get-url origin 2>/dev/null | grep -q "$REPO_PATH"; then
  rm -rf "$LINK"
fi
rm -rf "$SRC"

echo "Liquid Glass removed."
