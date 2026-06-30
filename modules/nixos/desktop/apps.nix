# Desktop apps: Flatpak + AppImage support
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.desktop.apps;
in {
  options.hex.nixos.desktop.apps = {
    flatpak = lib.mkEnableOption "Flatpak support" // {default = false;};
    appimage = lib.mkEnableOption "AppImage support" // {default = false;};
  };

  config = lib.mkMerge [
    # ── Flatpak ──────────────────────────────────────────────────────
    (lib.mkIf cfg.flatpak {
      services.flatpak.enable = true;

      # TODO: declarative packages

      home-manager.users.hexzii.home.packages = with pkgs; [
        flatpak
      ];
    })

    # ── AppImage ─────────────────────────────────────────────────────
    (lib.mkIf cfg.appimage {
      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    })
  ];
}
