# Desktop GUI packages
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.home.desktop.packages;
in {
  options.hex.nixos.home.desktop.packages = {
    enable = lib.mkEnableOption "desktop GUI packages (ghostty, firefox, vesktop, ayugram)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii.home.packages = with pkgs; [
      ghostty
      firefox
      vesktop
      ayugram-desktop
      mixxx
      zed-editor
      vscodium
      freetube
      mpv
      celluloid
      nwg-displays # GUI multi-monitor configurator
      nwg-look # GTK theme/cursor/icon settings GUI
      desktop-file-utils # update-desktop-database
    ];
  };
}
