# Hyprland compositor
# hyprland.lua managed via chezmoi (dotfiles/dot_config/hypr/hyprland.lua)
{
  lib,
  config,
  pkgs,
  self,
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

    # UWSM session env (kept inline — not managed by chezmoi)
    home-manager.users.hexzii = {
      xdg.configFile."uwsm/env".text = ''
        XCURSOR_SIZE=24
        XCURSOR_THEME=Bibata-Modern-Classic
        TERMINAL=ghostty
      '';

      # HM hyprland module: only used for plugins + extraConfig generation.
      # Both package and portalPackage must be null to avoid conflict with
      # NixOS programs.hyprland (which installs hyprland system-wide).
      # See:
      #   - issues/6373: package null + finalPackage.override crash
      #   - issues/6797: package null + plugins crash (finalPackage/bin/hyprctl)
      #   - wiki: https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/
      # Config content managed by chezmoi -> userdefined.lua
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        # hyprexpo for workspace overview — not using hyprspace or hymission
        plugins = [
          self.packages.${pkgs.stdenv.hostPlatform.system}.hyprglass
          self.packages.${pkgs.stdenv.hostPlatform.system}.hypr-kinetic-scroll
          self.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
          self.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
          pkgs.hyprlandPlugins.hypr-dynamic-cursors
        ];
        settings = {};
        extraConfig = ''
          pcall(require, "userdefined")
        '';
      };
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
