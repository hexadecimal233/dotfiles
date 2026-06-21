# niri compositor
# niri/config.kdl managed via chezmoi (dotfiles/dot_config/niri/config.kdl)
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.desktop;
in {
  config = lib.mkIf (cfg.enable && cfg.wm == "niri") {
    # Declare UWSM session name for the dispatcher
    hex.nixos.desktop.wmSession = lib.mkDefault "niri.desktop";

    # Enable the compositor
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    # xdg portal backends — gnome portal (ScreenCast) + gtk fallback (OpenURI etc.)
    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk # provides OpenURI interface
      ];
      config.niri.default = ["gnome" "gtk"];
    };

    # WM-specific session env — portals identify the DE via these
    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Niri";
      XDG_SESSION_DESKTOP = "Niri";
    };

    # niri config — managed by chezmoi
    # Point this to your chezmoi-managed niri config:
    # home-manager.users.hexzii.xdg.configFile."niri/config.kdl".source =
    #   ./dotfiles/dot_config/niri/config.kdl;
  };
}
