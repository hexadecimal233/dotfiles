# Hyprland compositor
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.desktop.hyprland;
in {
  config = lib.mkIf (config.hex.desktop.enable && cfg.enable) {
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

    # essential utilities for a minimal Hyprland session
    environment.systemPackages = with pkgs; [
      ghostty
      dunst # notification daemon
      wofi # launcher
      waybar # status bar
    ];
  };
}
