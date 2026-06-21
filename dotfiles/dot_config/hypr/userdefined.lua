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
        repeat_rate = 30,
        repeat_delay = 500,
        touchpad = { natural_scroll = true, scroll_factor = 0.2, drag_lock = true },
        follow_mouse = 0, -- Don't focus windows on hover (click/keybind only)
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
        workspace_swipe_forever = true, -- Don't clamp at neighbor workspaces
    },
    decoration = {
        rounding = 10,
        rounding_power = 4.0,   -- 2.0=circle, 4.0=squircle, 1.0=triangle
        active_opacity = 1.0,
        inactive_opacity = 1.0, -- Fully opaque unfocused
        fullscreen_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 14,                             -- Shadow spread
            render_power = 1,                       -- Shadow quality (1=softest falloff, 4=sharpest)
            offset = "0 6",
            color = "rgba(0, 0, 0, 0.21)",          -- Active/focused shadow (prominent)
            color_inactive = "rgba(0, 0, 0, 0.05)", -- Softer shadow on unfocused
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

-- Per-device input settings (sensitivity, scroll_factor, etc.)
require("devices")

hl.workspace_rule({
    workspace = "w[t1-4]", -- except workspace 1 for floating windows
    -- no_border = true, for apps be resizable
    no_rounding = true,
    gaps_in = 0,
    gaps_out = 0,
    -- decorate = false,
})

-- Pop in 200ms (open), fade 100ms (close), other animations inherit defaults
hl.curve("animEase", { type = "bezier", points = { { 0.23, 1.0 }, { 0.32, 1.0 } } })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "animEase", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = false })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "animEase" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "animEase" })

-- Workspace swap animation (macOS/Windows-style slide)
hl.curve("wsEase", { type = "bezier", points = { { 0.65, 0.0 }, { 0.35, 1.0 } } })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "wsEase", style = "slide 100%" })

-- fuck ms copilot key — remap to ghostty (placeholder, change the exec cmd later)
hl.bind("SUPER + SHIFT + code:201", hl.dsp.exec_cmd("ghostty"))

hl.bind("SUPER + W", hl.dsp.window.close())         -- close window (alternative)
hl.bind("SUPER + Q", hl.dsp.window.kill())          -- exit/kill program
hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))  -- toggle tiling/floating
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen())  -- fullscreen
hl.bind("SUPER + M", hl.dsp.window.move({ workspace = "special" }))  -- hide/minimize
hl.bind("SUPER + ALT + X", hl.dsp.exec_cmd("hyprctl kill"))  -- xkill mode (click to kill)
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
local hs = require("./scripts/hyprsplit")
hs.config({ num_workspaces = 10 })

-- Touchpad swipe gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- Per-monitor workspace switching via hyprsplit dispatchers
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("SUPER + " .. key, hs.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = false }))
end

-- Swap workspaces between monitors + grab orphaned windows
hl.bind("SUPER + D", hs.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }))
hl.bind("SUPER + G", hs.dsp.grab_rogue_windows())

require("./plugins/hyprglass")
require("./plugins/hypr-dynamic-cursors")
require("./plugins/hypr-kinetic-scroll")
require("./plugins/hyprexpo")

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
