-- nwg-displays manages monitors via ~/.config/hypr/monitors.lua
-- falls back to nothing if monitors.lua doesn't exist (first boot)
local ok = pcall(require, "monitors")

hl.env("XCURSOR_THEME", "aosp-cursors")
hl.env("XCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
  hl.exec_cmd("hyprctl setcursor aosp-cursors 24")
end)

hl.config({
  general = {
    border_size = 1,
    col = {
      active_border = "rgba(aaaaffff)",
      inactive_border = "rgba(666666ff)",
    },
    resize_on_border = false,
  },
  input = {
    kb_layout = "us",
    touchpad = { natural_scroll = true },
  },
  cursor = {
    enable_hyprcursor = false,
  },
  decoration = {
    rounding = 18,             -- Squircle corners (radius px)
    rounding_power = 4.0,      -- 2.0=circle, 4.0=squircle, 1.0=triangle
    active_opacity = 1.0,
    inactive_opacity = 1.0,    -- Fully opaque unfocused
    fullscreen_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 20,              -- Shadow spread
      render_power = 1,        -- Shadow quality (1=softest falloff, 4=sharpest)
      color = "rgba(0, 0, 0, 0.5)",           -- Active/focused shadow
      color_inactive = "rgba(0, 0, 0, 0.15)", -- Lighter shadow on unfocused
    },
    blur = {
      enabled = false,         -- Disabled — HyprGlass handles blur
    },
  },
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
  xwayland = {force_zero_scaling = true },
})

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("Print", hl.dsp.exec_cmd("grimblast copy area"))

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { repeating = true })

-- Workspaces (SUPER + 1-9)
-- Touchpad swipe gestures (macOS-like)
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9" }))

-- Move window to workspace (SUPER + SHIFT + 1-9)
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }))

-- HyprGlass - Liquid Glass visual effects
if hl.plugin.hyprglass then
  local hg = hl.plugin.hyprglass

  hg.config({
    default_theme = "dark",
    default_preset = "glass",
    tint_color = 0x8899aa22,
    brightness = 0.9,
    dark = { brightness = 0.82 },
    light = { adaptive_boost = 0.6 },
    layers = { enabled = 1 },
  })

  hg.layer("noctalia-wallpaper", { exclude = true })
  hg.layer("noctalia-desktop-widget", { exclude = true })
  hg.layer("noctalia-bar-default", { exclude = true })
  hg.layer("noctalia-dock", { exclude = true })

  hg.preset("glass", {
    blur_strength = 3.0,
    blur_iterations = 3,
    edge_thickness = 0.04,
    refraction_strength = 8.0,
    chromatic_aberration = 0.3,
    fresnel_strength = 0.8,
    specular_strength = 0.8,
    glass_opacity = 1.0,
    tint_color = 0xeeeeffaa,
  })
end
