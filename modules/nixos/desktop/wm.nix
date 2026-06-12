# Hyprland compositor
# Config managed via chezmoi (~/.config/hypr/), not inline Nix
{
  lib,
  config,
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

    # display manager for selecting Hyprland at login
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # hint Electron apps to use Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
