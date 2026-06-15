{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hex.shared.home.java;

  # Legacy JDKs to symlink into ~/.jdks/
  legacyJdks = {
    zulu8 = pkgs.zulu8;
    zulu11 = pkgs.zulu11;
    zulu17 = pkgs.zulu17;
    zulu21 = pkgs.zulu21;
  };
in {
  options.hex.shared.home.java = {
    enable = lib.mkEnableOption "Java ecosystem" // {default = false;};
    # multiple jdks: https://discourse.nixos.org/t/fix-collision-with-multiple-jdks/10812
    legacy = lib.mkEnableOption "legacy JDK support (zulu8, zulu11, zulu17, zulu21)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs; [
        zulu25 # Primary JDK
      ];

      home.sessionVariables =
        {
          JAVA_HOME = "${pkgs.zulu25.home}"; # primary home
        }
        // lib.optionalAttrs cfg.legacy {
          JAVA_8_HOME = "${pkgs.zulu8.home}";
          JAVA_11_HOME = "${pkgs.zulu11.home}";
          JAVA_17_HOME = "${pkgs.zulu17.home}";
          JAVA_21_HOME = "${pkgs.zulu21.home}";
        };

      # Symlink legacy JDKs to ~/.jdks/ — avoids bin/java collision
      home.file = lib.mkIf cfg.legacy (
        legacyJdks
        |> builtins.attrNames
        |> map (name: {
          name = ".jdks/${name}";
          value = {source = builtins.getAttr name legacyJdks;};
        })
        |> builtins.listToAttrs
      );

      home.sessionPath = lib.mkIf cfg.legacy ["$HOME/.jdks"];
    };
  };
}
