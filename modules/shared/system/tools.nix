# Cross-platform system tools (htop, btop, curl, wget, etc.)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.system;
in {
  options.hex.shared.system.tools = {
    enable = lib.mkEnableOption "cross-platform system tools (htop, btop, wget, etc.)" // {default = false;};
  };

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
      nh
      just
      python3 # latest stable
    ];
  };
}
