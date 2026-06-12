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

    # greetd — auto-login via UWSM (Noctalia's lock screen handles auth)
    services.greetd = {
      enable = true;
      restart = false;
      settings = {
        terminal.vt = 1;
        initial_session = {
          command = "${uwsm} start hyprland.desktop";
          user = "hexzii";
        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd '${uwsm} start hyprland.desktop'";
          user = "greeter";
        };
      };
    };

    # First-boot fallback Hyprland config — chezmoi overwrites later
    environment.etc."hypr/hyprland.conf".text = ''
      exec-once = qs -c noctalia-shell

      monitor = , preferred, auto, 1
      input { kb_layout = us }
      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
      }
      bind = SUPER, Q, killactive
      bind = SUPER, T, exec, ghostty
    '';

    # hint Electron apps to use Wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XCURSOR_SIZE = "24";
    };
  };
}
