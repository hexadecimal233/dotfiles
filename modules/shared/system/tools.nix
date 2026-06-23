# cross-platform system tools
# TODO: add virtualization stuff
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
      tree
      zip
      unzip

      # monitoring
      htop
      btop
      lsof

      # network / backup
      rsync
      rclone

      # dev infrastructure (on darwin part is installed via xcode)
      cmake
      nix-prefetch-git
      nix-prefetch-github
      nh
      just
      python3 # latest stable
    ];
  };
}
