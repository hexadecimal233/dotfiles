# Java ecosystem (Zulu JDK)
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
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs; [
        zulu25
      ];

      home.sessionVariables = {
        JAVA_HOME = "${pkgs.zulu25.home}";
      };
    };
  };
}
