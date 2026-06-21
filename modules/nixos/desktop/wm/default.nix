# WM dispatcher — always imported, enables greetd/UWSM/env for any WM
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.desktop;
  uwsm = lib.getExe config.programs.uwsm.package;
in {
  imports = [
    ./hyprland.nix
    ./niri.nix
  ];

  config = lib.mkIf (cfg.enable && cfg.wm != null) {
    # UWSM — systemd session manager, required by all WMs
    programs.uwsm.enable = true;

    # greetd — tuigreet login, then UWSM → selected WM
    services.greetd = {
      enable = true;
      restart = false;
      settings = {
        terminal.vt = 1;
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd '${uwsm} start ${cfg.wmSession}'";
          user = "greeter";
        };
      };
    };

    # xdg portals — shared base, WM-specific backends in each WM file
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "*";
    };

    # UWSM session env — shared across WMs, kept inline (not managed by chezmoi)
    home-manager.users.hexzii.xdg.configFile."uwsm/env".text = ''
      TERMINAL=ghostty
    '';

    # Session env — hint Electron apps to use Wayland, default tools
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      TERMINAL = "ghostty";
      EDITOR = "hx";
      VISUAL = "zeditor";
      # xdg-open: force portal path (async)
      NIXOS_XDG_OPEN_USE_PORTAL = "1";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
