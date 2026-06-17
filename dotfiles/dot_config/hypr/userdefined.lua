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
      active_border = "rgba(cccccc55)",
      inactive_border = "rgba(88888844)",
    },
    resize_on_border = true,
    snap = {
      enabled = true,
      window_gap = 8,
      monitor_gap = 8,
      border_overlap = true,
      respect_gaps = false,
    },
  },
  input = {
    kb_layout = "us",
    touchpad = { natural_scroll = true, scroll_factor = 0.3, drag_lock = true },
    follow_mouse = 0,           -- Don't focus windows on hover (click/keybind only)
  },
  cursor = {
    enable_hyprcursor = true,
  },
  gestures = {
    workspace_swipe_distance = 1200,
    workspace_swipe_invert = true,
    workspace_swipe_min_speed_to_force = 10,
    workspace_swipe_cancel_ratio = 0.4,
    workspace_swipe_direction_lock = false,
    workspace_swipe_create_new = true,
    workspace_swipe_forever = true,             -- Don't clamp at neighbor workspaces
  },
  decoration = {
    rounding = 18,             -- Squircle corners (radius px)
    rounding_power = 4.0,      -- 2.0=circle, 4.0=squircle, 1.0=triangle
    active_opacity = 1.0,
    inactive_opacity = 1.0,    -- Fully opaque unfocused
    fullscreen_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 14,              -- Shadow spread
      render_power = 1,        -- Shadow quality (1=softest falloff, 4=sharpest)
      color = "rgba(0, 0, 0, 0.25)",           -- Active/focused shadow (prominent)
      color_inactive = "rgba(0, 0, 0, 0.05)",  -- Softer shadow on unfocused
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

-- Pop in 200ms (open), fade 100ms (close), other animations inherit defaults
hl.curve("animEase", { type = "bezier", points = { {0.23, 1.0}, {0.32, 1.0} } })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "animEase", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = false })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "animEase" })

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
  hg.layer("noctalia-attached-panel", { exclude = true })
  hg.layer("noctalia-panel", { exclude = true })

  hg.preset("glass", {
    blur_strength = 3.0,
    blur_iterations = 3,
    edge_thickness = 0.015,
    refraction_strength = 14.0,
    chromatic_aberration = 0.5,
    fresnel_strength = 0.8,
    specular_strength = 0.8,
    glass_opacity = 1.0,
    tint_color = 0xeeeeff44,
  })
end
-- hyprbars - macOS-style title bars with traffic-light buttons
-- Known limitation: hyprbars can't detect Wayland xdg-decoration (CSD),
-- so bars appear on ALL windows including CSD apps (double-bar).
-- hyprbars:no_bar window rules can selectively disable per app if needed.
if hl.plugin.hyprbars then
  local hb = hl.plugin.hyprbars

  hl.config({
    plugin = {
      hyprbars = {
        bar_height = 28,
        bar_blur = true, -- :sob: this is disabled by hyprglass
        bar_part_of_window = true,
        bar_precedence_over_border = true,
        bar_padding = 10,
        bar_title_enabled = true,
        bar_text_size = 14,
        bar_text_weight = "medium",
        bar_text_align = "center";
        bar_buttons_alignment = "left",
        inactive_button_color = "rgba(aaaaaaff)",
        icon_on_hover = true,
        on_double_click = "hyprctl dispatch 'hl.dsp.window.fullscreen()'",
      },
    },
  })

  -- macOS traffic-light buttons (red / yellow / green)
  hb.add_button({
    icon = "✕",
    size = 14,
    bg_color = "rgb(ff5f56)",
    fg_color = "rgba(ffffff88)",
    action = "hyprctl dispatch 'hl.dsp.window.close()'",
  })
  hb.add_button({
    icon = "─",
    size = 14,
    bg_color = "rgb(ffbd2e)",
    fg_color = "rgb(ffffff)",
    -- movetoworkspacesilent: moves to special without focus change (no freeze)
    action = "hyprctl dispatch 'hl.dsp.window.move({ workspace = \"special\" })'",
  })
  hb.add_button({
    icon = "⛶",
    size = 14,
    bg_color = "rgb(27c93f)",
    fg_color = "rgb(ffffff)",
    action = "hyprctl dispatch 'hl.dsp.window.fullscreen()'",
  })
end

-- hypr-dynamic-cursors - shake to find cursor
if hl.plugin.dynamic_cursors then
  hl.config({ plugin = { dynamic_cursors = {
    enabled = true,
    mode = "none",   -- no tilt/rotate/stretch, just shake to find
    shake = {
      enabled = true,
      threshold = 6.0,
      base = 6.0,
      influence = 0.0,
      speed = 0.0,
      timeout = 400,
    },
    hyprcursor = { enabled = true, nearest = 1 },
  }}})
end

-- TEMP: hexadecimal233 fork w/ V2 API (upstream savonovv v0.3.1 crashed on 0.55.4 — uses V1 API)
if hl.plugin["hypr-kinetic-scroll"] then
  hl.config({ plugin = { ["kinetic-scroll"] = {
    enabled = true,
    decel = 12.0,
    min_velocity = 1.3,
    interval_ms = 8,
    delta_multiplier = 1.25,
    disable_in_browser = true,
    stop_on_target_change = true,
    stop_on_touchpad_gesture = true,
    stop_delay_ms = 20,
    stop_on_click = false,
    stop_on_focus = false,
    debug = false,
  }}})
end

-- Floating mode by default (macOS-like stacking behavior)
hl.window_rule({
  match = { class = ".*" },
  float = true,
  -- center = true, -- commented: causes XWayland menus (Wine, etc.) to auto-center
  persistent_size = true,
})

-- TODO: Windows-style cascading offset from center.
--       Use hl.on("windowOpened", ...) to track window count
--       and apply incremental (x + 30, y + 30) offset.
