# system-level tools
{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.hex.system.tools.enable {
    environment.systemPackages = with pkgs; [
      # files
      wget
      curl
      zip
      unzip

      # monitoring
      psmisc
      powertop
      htop
      atop
      btop
      iotop
      lsof

      # hardware
      lshw
      pciutils
      usbutils
      dmidecode
      lm_sensors
      efibootmgr

      # network
      rustnet
      vnstat
      wavemon
      ethtool
      iperf3
      dnsutils
      net-tools
      rsync

      # graphics
      vulkan-tools
      vulkan-loader
      clinfo
      mesa-demos
    ];
  };
}
