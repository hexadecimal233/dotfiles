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
        hl.on("hyprland.start", function()
          hl.exec_cmd("noctalia")
        end)

        hl.config({
          input = { kb_layout = "us" },
          misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
          },
        })

        hl.bind("SUPER + Q", hl.dsp.window.close())
        hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
        hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("hyprlauncher"))
        hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
        hl.bind("Print", hl.dsp.exec_cmd("grimblast copy area"))
      '';
      # UWSM session env
      xdg.configFile."uwsm/env".text = "XCURSOR_SIZE=24";
    };

    # hint Electron apps to use Wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XCURSOR_SIZE = "24";
    };
  };
}
