# Network management (NetworkManager, network tools, dae proxy)
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
    dae.enable = lib.mkEnableOption "dae transparent proxy (eBPF-based)" // {default = false;};
  };

  config = lib.mkMerge [
    # NetworkManager + tools
    (lib.mkIf cfg.enable {
      networking.networkmanager.enable = true;
      # networking.hostName = "nixos";
      services.vnstat.enable = true; # network statistics

      environment.systemPackages = with pkgs; [
        ethtool # NIC info/config
        iproute2 # ip, ss, tc
        vnstat # traffic monitor
        tcpdump # traffic capture
      ];
    })

    # dae transparent proxy
    (lib.mkIf cfg.dae.enable {
      services.dae = {
        enable = true;
        openFirewall = {
          enable = true;
          port = 12345;
        };
        assets = with pkgs; [v2ray-geoip v2ray-domain-list-community];
        # Config file managed externally (e.g. /etc/dae/config.dae)
        # configFile = "/etc/dae/config.dae";
      };
    })
  ];
}
