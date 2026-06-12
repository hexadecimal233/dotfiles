# Hyprland compositor
# Config managed via chezmoi (~/.config/hypr/), not inline Nix
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.desktop.hyprland;
  uwsm = lib.getExe config.programs.uwsm.package;
in {
  config = lib.mkIf (config.hex.nixos.desktop.enable && cfg.enable) {
    # enable the compositor with UWSM for proper systemd integration
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    # greetd — tuigreet login, then UWSM → Hyprland
    services.greetd = {
      enable = true;
      restart = false;
      settings = {
        terminal.vt = 1;
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd '${uwsm} start hyprland.desktop'";
          user = "greeter";
        };
      };
    };

    # Direct Hyprland Lua config — bypasses broken HM generator
    home-manager.users.hexzii = {
      xdg.configFile."hypr/hyprland.lua".text = ''
        -- nwg-displays manages monitors via ~/.config/hypr/monitors.lua
        -- falls back to nothing if monitors.lua doesn't exist (first boot)
        local ok = pcall(require, "monitors")

        hl.on("hyprland.start", function()
          hl.exec_cmd("noctalia")
        end)

        hl.config({
          input = {
            kb_layout = "us",
            touchpad = { natural_scroll = true },
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
      '';
      # UWSM session env
      xdg.configFile."uwsm/env".text = ''
        XCURSOR_SIZE=24
        TERMINAL=ghostty
      '';
    };

    # hint Electron apps to use Wayland + default terminal
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XCURSOR_SIZE = "24";
      TERMINAL = "ghostty";
      EDITOR = "hx";
      VISUAL = "hx";
    };
  };
}
