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
    gaps_workspaces = 20,
    border_size = 1,
    col = {
      active_border = "rgba(cccccc55)",
      inactive_border = "rgba(88888844)",
    },
    resize_on_border = true,
    extend_border_grab_area = 8,
    snap = {
      enabled = true,
      window_gap = 8,
      monitor_gap = 8,
      border_overlap = true,
      respect_gaps = false,
    },
    -- layout = "scrolling",
    -- allow_tearing = true,
  },
  input = {
    kb_layout = "us",
    sensitivity = -0.1, --(range: -1.0 to 1.0)
    touchpad = { natural_scroll = true, scroll_factor = 0.2, drag_lock = true },
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
    rounding = 10,             -- Squircle corners (radius px)
    rounding_power = 4.0,      -- 2.0=circle, 4.0=squircle, 1.0=triangle
    active_opacity = 1.0,
    inactive_opacity = 1.0,    -- Fully opaque unfocused
    fullscreen_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 14,              -- Shadow spread
      render_power = 1,        -- Shadow quality (1=softest falloff, 4=sharpest)
      offset = "0 6",
      color = "rgba(0, 0, 0, 0.21)",           -- Active/focused shadow (prominent)
      color_inactive = "rgba(0, 0, 0, 0.05)",  -- Softer shadow on unfocused
    },
    blur = {
      enabled = true,
      size = 8,
      passes = 2,
      -- xray = true,
      -- noise = 0.16,
      popups = true,
    },
    motion_blur = {
      --  enabled = true,
    }
  },
  misc = {
    disable_hyprland_logo = true,
    -- background_color = "rgb(000000)",
    disable_splash_rendering = true,
    -- vrr = 3,
  },
  xwayland = {
    -- force_zero_scaling = true, too small
    use_nearest_neighbor = false, -- bit windows like but okay burry :/
  },
})

hl.workspace_rule({
  workspace = "w[t1-4]", -- except workspace 1 for floating windows
  -- no_border = true, for apps be resizable
  no_rounding = true,
  gaps_in = 0,
  gaps_out = 0,
  -- decorate = false,
})

-- Pop in 200ms (open), fade 100ms (close), other animations inherit defaults
hl.curve("animEase", { type = "bezier", points = { {0.23, 1.0}, {0.32, 1.0} } })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "animEase", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = false })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "animEase" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "animEase" })

-- Workspace swap animation (macOS/Windows-style slide)
hl.curve("wsEase", { type = "bezier", points = { {0.65, 0.0}, {0.35, 1.0} } })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "wsEase", style = "slide 100%" })

-- fuck ms copilot key — remap to ghostty (placeholder, change the exec cmd later)
hl.bind("SUPER + SHIFT + code:201", hl.dsp.exec_cmd("ghostty"))

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
-- todo: screenshot hl.bind("Print", hl.dsp.exec_cmd(""))

-- lock with noctalia's built-in lockscreen
hl.bind("SUPER + L", hl.dsp.exec_cmd("noctalia msg session lock"))

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 3%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 3%-"), { repeating = true })

-- hyprsplit — per-monitor independent workspaces (awesome/dwm-like)
local hs = require("./plugins/hyprsplit")
hs.config({ num_workspaces = 10 })

-- Touchpad swipe gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- Per-monitor workspace switching via hyprsplit dispatchers
for i = 1, 10 do
  local key = i % 10  -- 10 maps to key 0
  hl.bind("SUPER + " .. key, hs.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = false }))
end

-- Swap workspaces between monitors + grab orphaned windows
hl.bind("SUPER + D", hs.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }))
hl.bind("SUPER + G", hs.dsp.grab_rogue_windows())

-- HyprGlass - Liquid Glass visual effects
if hl.plugin.hyprglass then
  local hg = hl.plugin.hyprglass

  hg.config({
    enabled = false, -- currently disables it cuz artifacts
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
        bar_blur = false, -- :sob: this is disabled by hyprglass
        bar_part_of_window = true,
        -- bar_color = "rgba(fefefeff)",
        -- 
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

  -- macOS traffic-light buttons (red / yellow / green / blue)
  hb.add_button({
    icon = "x",
    size = 14,
    bg_color = "rgb(ff5f56)",
    fg_color = "rgba(ffffff88)",
    action = "hyprctl dispatch 'hl.dsp.window.close()'",
  })
  hb.add_button({
    icon = "-",
    size = 14,
    bg_color = "rgb(ffbd2e)",
    fg_color = "rgb(ffffff)",
    -- movetoworkspacesilent: moves to special without focus change (no freeze)
    action = "hyprctl dispatch 'hl.dsp.window.move({ workspace = \"special\" })'",
  })
  hb.add_button({
    icon = "/",
    size = 14,
    bg_color = "rgb(27c93f)",
    fg_color = "rgb(ffffff)",
    action = "hyprctl dispatch 'hl.dsp.window.fullscreen()'",
  })
  hb.add_button({
    icon = "=",
    size = 14,
    bg_color = "rgb(0044cc)",
    fg_color = "rgb(ffffff)",
    action = "hyprctl dispatch 'hl.dsp.window.float({ action = \"unset\" })'",
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

-- hyprexpo - expose-style workspace overview grid
if hl.plugin.hyprexpo then
  hl.config({
    plugin = {
      hyprexpo = {
        columns = 3,
        gaps_in = 5,
        gaps_out = 0,
        bg_col = "rgb(111111)",
        workspace_method = "center current",
        gesture_distance = 200,
        cancel_key = "escape",
        show_cursor = 1,
        label_enable = 1,
        label_show = "always",
        label_text_mode = "token",
        label_token_map = "1,2,3,4,5,6,7,8,9,0",
        keynav_enable = 1,
        keynav_wrap_h = 1,
        keynav_wrap_v = 1,
      },
    },
  })

  -- 三指上滑 → 切換 overview
  hl.plugin.hyprexpo.gesture({
    fingers = 3,
    direction = "up",
    action = "expo",
  })

  -- Super + Tab → toggle
  hl.bind("SUPER + TAB", function()
    hl.plugin.hyprexpo.expo("toggle")
  end)
  hl.bind("SUPER + SHIFT + TAB", function()
    hl.plugin.hyprexpo.expo("on")
  end)
  hl.bind("SUPER + Escape", function()
    hl.plugin.hyprexpo.expo("cancel")
  end)
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
