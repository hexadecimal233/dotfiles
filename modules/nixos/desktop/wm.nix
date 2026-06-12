# Hyprland compositor
# Config managed via chezmoi (~/.config/hypr/), not inline Nix
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.desktop.hyprland;
in {
  config = lib.mkIf (config.hex.nixos.desktop.enable && cfg.enable) {
    # enable the compositor with UWSM for proper systemd integration
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    # greetd — auto-login into Hyprland (Noctalia's lock screen handles auth)
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "hexzii";
        };
      };
    };

    # hint Electron apps to use Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
