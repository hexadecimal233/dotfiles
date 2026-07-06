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

    # daed transparent proxy — FIXME: broken build (upstream pnpmDepsHash mismatch)
    # (lib.mkIf cfg.dae.enable {
    #   services.daed = {
    #     enable = true;
    #     configDir = "/etc/daed";
    #     listen = "127.0.0.1:2023";
    #     assetsPaths = with pkgs; [
    #       "${v2ray-geoip}/share/v2ray/geoip.dat"
    #       "${v2ray-domain-list-community}/share/v2ray/geosite.dat"
    #     ];
    #     openFirewall = {
    #       enable = true;
    #       port = 12345;
    #     };
    #   };
    # })
  ];
}
