# linux-only system tools
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.tools;
in {
  config = lib.mkIf config.hex.nixos.system.tools.enable {
    environment.systemPackages = with pkgs; (
      # monitoring (linux-only)
      lib.optionals cfg.monitoring [
        psmisc
        powertop
        atop
        iotop
      ]
    ) ++ (
      # hardware (linux-only)
      lib.optionals cfg.hardware [
        lshw
        pciutils
        usbutils
        dmidecode
        lm_sensors
        efibootmgr
      ]
    ) ++ (
      # network (linux-only)
      lib.optionals cfg.network [
        rustnet
        wavemon
        vnstat
        ethtool
        iproute2
      ]
    ) ++ (
      # graphics (linux-only)
      lib.optionals cfg.graphics [
        vulkan-tools
        vulkan-loader
        clinfo
        mesa-demos
      ]
    );
  };
}
