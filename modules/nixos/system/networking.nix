# Network management (NetworkManager, network tools)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.networking;
in {
  options.hex.nixos.system.networking = {
    enable = lib.mkEnableOption "network management (NetworkManager)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
    # networking.hostName = "nixos";
    services.vnstat.enable = true; # network statistics

    environment.systemPackages = with pkgs; [
      ethtool # NIC info/config
      iproute2 # ip, ss, tc
      vnstat # traffic monitor
    ];
  };
}
