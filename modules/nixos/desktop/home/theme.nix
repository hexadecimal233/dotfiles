# Desktop theming (icons, cursor, GTK)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.home.desktop.theme;
in {
  options.hex.nixos.home.desktop.theme = {
    enable = lib.mkEnableOption "desktop theme (Papirus icons, AOSP cursor)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs; [
        papirus-icon-theme
      ];

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };
      };
    };
  };
}
