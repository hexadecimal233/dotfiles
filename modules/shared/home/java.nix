# Java ecosystem (Zulu JDKs, JDT LS, Minecraft)
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hex.shared.home.java;
in {
  options.hex.shared.home.java = {
    enable = lib.mkEnableOption "Java ecosystem" // {default = false;};

    minecraft = {
      enable = lib.mkEnableOption "minecraft & legacy jdk support" // {default = false;};
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs;
        [
          # jdk
          zulu25
        ]
        ++ lib.optionals cfg.minecraft.enable [
          # minecaft launchers
          hmcl
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

          zulu21
          zulu17
          zulu8
        ];

      home.sessionVariables =
        {
          JAVA_HOME = "${pkgs.zulu25.home}";
        }
        // lib.optionalAttrs cfg.minecraft.enable {
          JAVA8_HOME = "${pkgs.zulu8.home}";
          JAVA21_HOME = "${pkgs.zulu21.home}";
          JAVA17_HOME = "${pkgs.zulu17.home}";
        };
    };
  };
}
