#!/bin/bash
# Liquid Glass island bar: builds a copy of this machine's stock Omarchy bar with
# islands.patch applied, so it always matches the installed Omarchy version.
# The islands only show while the liquid-glass theme is active; on any other
# theme the bar looks and works like the stock one.
#
#   sync.sh install   build it and switch the bar to it
#   sync.sh update    rebuild after an Omarchy update (no-op when nothing changed)
#   sync.sh remove    switch back to the stock bar and delete it

set -euo pipefail

ID="liquid-glass.bar"
HERE=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)
PATCH="$HERE/islands.patch"
PLUGINS="$HOME/.config/omarchy/plugins"
TARGET="$PLUGINS/$ID"
STAMP=".liquid-glass-stamp"
HOOKS="$HOME/.config/omarchy/hooks"
HOOK_NAME="liquid-glass-bar"

notify() { omarchy-notification-send -g 󰐱 "Liquid Glass" "$1" >/dev/null 2>&1 || true; }

stock_dir() {
  omarchy-plugin-catalog | jq -r '.[] | select(.firstParty and .id == "omarchy.bar") | .sourceDir'
}

# Changes whenever the stock bar or our patch changes.
stamp_for() {
  { (cd "$1" && find . -type f -print0 | sort -z | xargs -0 sha256sum); sha256sum <"$PATCH"; } | sha256sum | cut -d' ' -f1
}

# Omarchy draws islands itself once its stock bar reads [bar] style, which the
# theme's shell.toml sets; the bundled copy is then not needed.
native_islands() {
  local src
  src=$(stock_dir)
  [[ -n $src ]] && grep -q "Style.bar.style" "$src/Bar.qml"
}

# Another bar clone the user made themselves; we never replace it.
other_bar() {
  omarchy-plugin-list --json | jq -r --arg id "$ID" \
    '.[] | select(.id != $id and .clonedFrom == "omarchy.bar" and .enabled) | .id' | head -1
}

# Builds into a hidden staging folder, then swaps it in with one rename so the
# shell never sees the bar plugin missing.
build() {
  local src stage
  src=$(stock_dir)
  [[ -n $src && -f $src/Bar.qml ]] || { echo "Stock Omarchy bar not found." >&2; return 1; }

  mkdir -p "$PLUGINS"
  stage=$(mktemp -d "$PLUGINS/.liquid-glass.XXXXXX")
  cp -aL "$src/." "$stage/"

  # The ceiling stops git from treating a repo that happens to hold ~/.config as the target.
  if ! (cd "$stage" && GIT_CEILING_DIRECTORIES="$PLUGINS" git apply -p1 "$PATCH" 2>/dev/null); then
    rm -rf "$stage"
    return 2
  fi

  jq --arg id "$ID" '
    .id = $id |
    .name = "Liquid Glass Bar" |
    .description = "Omarchy bar with floating islands for the Liquid Glass theme" |
    .omarchy = ((if (.omarchy | type) == "object" then .omarchy else {} end) + { clonedFrom: "omarchy.bar" }) |
    del(.omarchy.clonePaths)
  ' "$stage/manifest.json" >"$stage/manifest.json.tmp"
  mv "$stage/manifest.json.tmp" "$stage/manifest.json"
  stamp_for "$src" >"$stage/$STAMP"

  if [[ -d $TARGET ]]; then
    mv -T --exchange "$stage" "$TARGET" || { rm -rf "$stage"; return 1; }
    rm -rf "$stage"
  else
    mv -T "$stage" "$TARGET" || { rm -rf "$stage"; return 1; }
  fi
}

install_hooks() {
  local dir
  for dir in post-update.d post-boot.d; do
    mkdir -p "$HOOKS/$dir"
    cat >"$HOOKS/$dir/$HOOK_NAME" <<'EOF'
# Liquid Glass theme: rebuild the island bar when the stock Omarchy bar changes.
sync="$(readlink -f "$HOME/.config/omarchy/themes/liquid-glass")/bar/sync.sh"
[[ -f $sync ]] && bash "$sync" update
EOF
  done
}

remove_hooks() {
  rm -f "$HOOKS/post-update.d/$HOOK_NAME" "$HOOKS/post-boot.d/$HOOK_NAME"
}

remove_plugin() {
  if [[ -d $TARGET ]]; then
    omarchy plugin remove "$ID" --yes >/dev/null
  fi
  rm -rf "$PLUGINS"/."$ID".bak.*
}

case "${1:-}" in
install)
  if native_islands; then
    remove_plugin
    remove_hooks
    echo "Omarchy draws the island bar itself; nothing extra to install."
    exit 0
  fi
  existing=$(other_bar)
  if [[ -n $existing ]]; then
    echo "Skipping the island bar: you already use your own bar ($existing)." >&2
    exit 0
  fi
  status=0
  build || status=$?
  if (( status == 2 )); then
    echo "Skipping the island bar: it does not fit this Omarchy version's bar." >&2
    exit 0
  elif (( status != 0 )); then
    echo "Skipping the island bar: it could not be built." >&2
    exit 0
  fi
  install_hooks
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
  for _ in $(seq 40); do
    omarchy-plugin-list --json | jq -e --arg id "$ID" 'any(.[]; .id == $id)' >/dev/null && break
    sleep 0.05
  done
  omarchy-plugin-enable "$ID" >/dev/null
  omarchy restart shell >/dev/null 2>&1 || true
  echo "Island bar installed."
  ;;
update)
  [[ -d $TARGET ]] || exit 0
  if native_islands; then
    remove_plugin
    remove_hooks
    notify "Omarchy now draws the island bar itself, so the theme's own copy was removed."
    exit 0
  fi
  src=$(stock_dir)
  [[ -n $src ]] || exit 0
  [[ $(cat "$TARGET/$STAMP" 2>/dev/null) == "$(stamp_for "$src")" ]] && exit 0
  status=0
  build || status=$?
  if (( status == 0 )); then
    omarchy restart shell >/dev/null 2>&1 || true
  elif (( status == 2 )); then
    # The patch no longer fits the new stock bar: fall back to stock.
    remove_plugin
    remove_hooks
    notify "Omarchy's bar changed, so the island bar was switched off and the stock bar is back. Update the theme by re-running its install line to get the islands back."
  fi
  ;;
remove)
  remove_plugin
  remove_hooks
  ;;
*)
  echo "Usage: sync.sh install|update|remove" >&2
  exit 1
  ;;
esac
