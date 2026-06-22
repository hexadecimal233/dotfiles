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
    flatpak = lib.mkEnableOption "Flatpak support";
    appimage = lib.mkEnableOption "AppImage support";
  };

  config = lib.mkIf config.hex.nixos.desktop.enable (lib.mkMerge [
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
  ]);
}
