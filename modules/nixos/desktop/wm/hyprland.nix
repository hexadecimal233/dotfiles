# Hyprland compositor
# hyprland.lua managed via chezmoi (dotfiles/dot_config/hypr/hyprland.lua)
{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.hex.nixos.desktop;
in {
  config = lib.mkIf (cfg.enable && cfg.wm == "hyprland") {
    # Declare UWSM session name for the dispatcher
    hex.nixos.desktop.wmSession = lib.mkDefault "hyprland.desktop";

    # Enable the compositor with UWSM for proper systemd integration
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    # xdg portal backends — hyprland portal + gtk fallback (OpenURI etc.)
    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk # provides OpenURI interface (hyprland portal lacks it)
      ];
      config.hyprland.default = ["hyprland" "gtk"];
    };

    # WM-specific session env — portals identify the DE via these
    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    # HM hyprland module: only used for plugins + extraConfig generation.
    # Both package and portalPackage must be null to avoid conflict with
    # NixOS programs.hyprland (which installs hyprland system-wide).
    # See:
    #   - issues/6373: package null + finalPackage.override crash
    #   - issues/6797: package null + plugins crash (finalPackage/bin/hyprctl)
    #   - wiki: https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/
    # Config content managed by chezmoi -> userdefined.lua
    home-manager.users.hexzii.wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      # hyprexpo for workspace overview — not using hyprspace or hymission
      plugins = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.hyprglass
        self.packages.${pkgs.stdenv.hostPlatform.system}.hypr-kinetic-scroll
        self.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
        pkgs.hyprlandPlugins.hypr-dynamic-cursors
      ];
      settings = {};
      extraConfig = ''
        pcall(require, "userdefined")
      '';
    };
  };
}
