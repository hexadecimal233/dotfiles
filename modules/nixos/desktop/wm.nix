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

    # HM-level Hyprland config (generates ~/.config/hypr/hyprland.conf)
    home-manager.users.hexzii.wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
      systemd.enable = false;
      settings.exec-once = ["noctalia"];
      extraConfig = ''
        $mod = SUPER
        bind = $mod, T, exec, ghostty
        bind = $mod, Q, killactive
        bind = $mod, SPACE, exec, ghostty
        bind = $mod, E, exec, nautilus
        bind = , Print, exec, grimblast copy area
      '';
    };

    # hint Electron apps to use Wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XCURSOR_SIZE = "24";
    };
  };
}
