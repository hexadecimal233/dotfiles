# Desktop GUI packages
{
  lib,
  config,
  pkgs,
  monique,
  ...
}: let
  cfg = config.hex.nixos.home.desktop.packages;
in {
  imports = [monique.nixosModules.default];

  options.hex.nixos.home.desktop.packages = {
    enable = lib.mkEnableOption "desktop GUI packages (ghostty, firefox, vesktop, ayugram)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    programs.monique.enable = true;
    home-manager.users.hexzii.home.packages = with pkgs; [
      ghostty
      firefox
      vesktop
      ayugram-desktop
      zed-editor
      vscodium
      freetube
      mpv
      celluloid
      nwg-displays
      nwg-look # GTK theme/cursor/icon settings GUI
      desktop-file-utils # update-desktop-database
      nautilus # GNOME file manager (bound to SUPER+E)
      libreoffice-fresh
      obs-studio
      # bitwarden-desktop FIXME: outdated electron
      sourcegit # todo: watch 4 updates

      # hyprland-exclusiv! TODO: move to wm
      hyprshade
    ];
  };
}
