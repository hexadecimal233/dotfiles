# linux-only system tools
{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.hex.nixos.system.tools.enable {
    environment.systemPackages = with pkgs; [
      # monitoring (linux-only)
      psmisc
      powertop
      atop
      iotop

      # hardware (linux-only)
      lshw
      pciutils
      usbutils
      dmidecode
      lm_sensors
      efibootmgr

      # network (linux-only)
      rustnet
      vnstat
      wavemon
      ethtool
      iperf3
      dnsutils
      net-tools

      # graphics (linux-only)
      vulkan-tools
      vulkan-loader
      clinfo
      mesa-demos
    ];
  };
}
