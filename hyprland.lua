-- Liquid Glass: bright, clear frosted glass with soft squircle corners,
-- a thin light-catching rim, and a floating shadow.
local active_border_color = { colors = { "rgba(ffffff66)", "rgba(ffffff1a)" }, angle = 45 }
local inactive_border_color = "rgba(ffffff1f)"

hl.config({
  general = {
    border_size = 1,
    -- The bar's islands float 5px off the screen edge; a 5px top gap leaves
    -- the same space under them as above them.
    gaps_out = { top = 5, right = 10, bottom = 10, left = 10 },
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
  },

  decoration = {
    rounding = 16,
    rounding_power = 4,

    shadow = {
      enabled = true,
      range = 24,
      render_power = 3,
      offset = "0 6",
      color = "rgba(00000066)",
      color_inactive = "rgba(00000033)",
    },

    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      new_optimizations = true,
      xray = false,
      contrast = 1.0,
      brightness = 1.0,
      noise = 0.015,
      vibrancy = 0.5,
      vibrancy_darkness = 0.2,
      popups = true,
      special = true,
    },
  },
})

-- Frost every Omarchy shell surface: bar, menus, notifications, OSD, prompts.
hl.layer_rule({
  match = { namespace = "^(omarchy-bar|omarchy-menu|omarchy-notifications|omarchy-osd|omarchy-polkit|omarchy-reminders|omarchy-clipboard|omarchy-emojis|omarchy-image-selector|omarchy-keyboard-panel|omarchy-network-qr|omarchy-dock|omarchy-dock-apps)$" },
  blur = true,
  ignore_alpha = 0.1,
})
