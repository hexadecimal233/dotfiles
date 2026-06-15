# Minecraft launchers + legacy JDKs
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hex.nixos.home.desktop.minecraft;
in {
  options.hex.nixos.home.desktop.minecraft = {
    enable = lib.mkEnableOption "minecraft & legacy jdk support" // {default = false;};
  };

  config = lib.mkIf (config.hex.nixos.home.desktop.enable && cfg.enable) {
    home-manager.users.hexzii = {
      home.packages = with pkgs; [
        # minecaft launchers
        (hmcl.override {
          hmclJdk = zulu25.override { enableJavaFX = true; };
          minecraftJdks = [
            zulu25
            zulu21
            zulu17
            zulu8
          ];
        })
        (prismlauncher.override {
          # Add binary required by some mod
          additionalPrograms = [ffmpeg-full];

          # Change Java runtimes available to Prism Launcher
          jdks = [
            zulu25
            zulu21
            zulu17
            zulu8
          ];
        })
      ];
    };
  };
}
