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
  input = {
    kb_layout = "us",
    touchpad = { natural_scroll = true },
  },
  cursor = {
    enable_hyprcursor = false,
  },
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
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
