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
    # Legacy JDKs (zulu8/zulu17/zulu21) come from hex.shared.home.java.legacy
    assertions = [{
      assertion = config.hex.shared.home.java.legacy;
      message = "minecraft requires hex.shared.home.java.legacy to be enabled (provides zulu8/zulu17/zulu21 for launcher runtimes)";
    }];

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
