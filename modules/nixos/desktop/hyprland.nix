# Hyprland compositor
# TODO: this is just for temporary state, and might be ai slops inside
# in the future, we may use HM to manage config
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

    # system-level hyprland config
    # user's ~/.config/hypr/hyprland.conf overrides this at runtime
    environment.etc."hypr/hyprland.conf".text = ''
      $terminal = ghostty
      $fileManager = nautilus
      $menu = wofi --show drun

      # keybindings
      bind = SUPER, Q, exec, $terminal
      bind = SUPER, E, exec, $fileManager
      bind = SUPER, SPACE, exec, $menu

      # essential env
      env = XCURSOR_SIZE,24

      # general
      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
      }
    '';

    # tell Hyprland where to find the system config
    environment.sessionVariables.HYPRLAND_CONFIG = "/etc/hypr/hyprland.conf";

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
