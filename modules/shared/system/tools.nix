# cross-platform system tools
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.system;
in {
  config = lib.mkIf cfg.tools.enable {
    home-manager.users.hexzii.home.packages = with pkgs; [
      # files
      wget
      curl
      zip
      unzip

      # monitoring
      htop
      btop
      lsof

      # network
      rsync

      # dev infrastructure
      gnumake
      nh
      just
      docker-compose
      python3
    ];
  };
}
