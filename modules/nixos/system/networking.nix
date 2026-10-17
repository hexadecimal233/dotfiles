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
    dae.enable = lib.mkEnableOption "daed transparent proxy (eBPF-based, with web dashboard)" // {default = false;};
  };

  config = lib.mkMerge [
    # NetworkManager + tools
    (lib.mkIf cfg.enable {
      networking.networkmanager.enable = true;
      networking.networkmanager.wifi.macAddress = "stable"; # prevent tracking
      # networking.hostName = "nixos";
      #
      # TODO: optional enalbe
      services.vnstat.enable = true; # network statistics

      environment.systemPackages = with pkgs; [
        ethtool # NIC info/config
        iproute2 # ip, ss, tc
        vnstat # traffic monitor
        tcpdump # traffic capture
      ];
    })

    {
      networking.nftables = {
        enable = true; # use nftables instead of iptables-nft
      };
    }
  ];
}
