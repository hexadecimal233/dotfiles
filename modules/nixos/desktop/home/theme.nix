# Desktop theming (icons, cursor, GTK)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.home.desktop.theme;

  # AOSP cursors from GitHub releases
  aosp-cursors = pkgs.stdenv.mkDerivation {
    pname = "aosp-cursors";
    version = "1.1.0";
    src = pkgs.fetchurl {
      url = "https://github.com/Tech-Tac/aosp-cursors/releases/download/1.1.0/aosp-cursors-linux-1.1.0.tar.xz";
      hash = "sha256-9yv1fNyI6RFzD8H+X2RVx9/+reX6wM+ZW6DIq4yfp3o=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/icons
      tar -xJf $src -C $out/share/icons
    '';
  };
in {
  options.hex.nixos.home.desktop.theme = {
    enable = lib.mkEnableOption "desktop theme (Papirus icons, AOSP cursor)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs; [
        papirus-icon-theme
        aosp-cursors
      ];

      home.pointerCursor = {
        gtk.enable = true;
        package = aosp-cursors;
        name = "aosp-cursors";
        size = 24;
      };

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };
        cursorTheme = {
          package = aosp-cursors;
          name = "aosp-cursors";
          size = 24;
        };
      };
    };
  };
}
