# Liquid Glass

[![Built for Omarchy: Theme](https://raw.githubusercontent.com/tcballard/omarchy-badges/75975e5b5bf75e7ede3764bcd2950046f7abfe2c/badges/v1/omarchy-theme.svg)](https://github.com/tcballard/omarchy-badges)

An Apple Liquid Glass style theme for [Omarchy](https://omarchy.org): frosted see-through windows, soft squircle corners, and a thin light-catching rim.

![Liquid Glass](preview.webp)

<sub>The floating island top bar in the screenshot is a separate bar tweak and is not part of this theme.</sub>

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/FarzadHayat/omarchy-liquid-glass-theme/main/install.sh | bash
```

Why not `omarchy theme install`? For a theme cloned from git, Omarchy only keeps colors, images and shell styling. It drops `hyprland.lua` and the terminal configs, and those carry the blur, rounding, rim and see-through terminals. The installer clones the repo to `~/.local/share/omarchy-liquid-glass-theme` and links it into your themes folder, so Omarchy uses all of it.

Want colors and wallpapers only? That still works:

```bash
omarchy theme install https://github.com/FarzadHayat/omarchy-liquid-glass-theme
```

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/FarzadHayat/omarchy-liquid-glass-theme/main/uninstall.sh | bash
```

If Liquid Glass is active, this switches you to Tokyo Night first, then removes the link and the cloned repo.

## What you get

- Frosted blur behind see-through windows, the bar, menus, notifications and the OSD
- 16px squircle corners, a 1px white gradient rim, and a soft floating shadow
- Terminals (Alacritty, Foot, Kitty, Ghostty) at 70% opacity
- Apple dark mode system colors, `Yaru-blue-dark` icons
- Three blurred color wallpapers, each with a matching 5 second intro video

## Palette

| Role | Hex |
|------|-----|
| Background | `#1c1c1e` |
| Foreground | `#f5f5f7` |
| Accent / Blue | `#0a84ff` |
| Red | `#ff453a` |
| Orange | `#ff9f0a` |
| Yellow | `#ffd60a` |
| Green | `#30d158` |
| Cyan | `#64d2ff` |
| Magenta | `#bf5af2` |

## Backgrounds

- `1-liquid-aurora.webp`
- `2-liquid-lagoon.webp`
- `3-liquid-ember.webp`

Cycle with Super + Ctrl + Space.

## Performance

The blur costs a little GPU while the screen is changing, and next to nothing at idle. On a Radeon 780M at 4K, idle GPU use went from about 1.5% with no blur to about 4% with this theme.

## More for Omarchy

See everything else I've built for Omarchy, each with a one-line install, at **[omarchy.farzadhayat.dev](https://omarchy.farzadhayat.dev)**.
