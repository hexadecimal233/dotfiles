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
    environment.systemPackages = with pkgs;
      [
        openssl
      ]
      ++ (
        # monitoring (linux-only)
        lib.optionals cfg.monitoring [
          psmisc
          atop
          iotop
        ]
      )
      ++ (
        # hardware (linux-only)
        lib.optionals cfg.hardware [
          lshw
          pciutils
          usbutils
          dmidecode
          fetchutils
          cpufrequtils
          i2c-tools
          lm_sensors

          beep

          efibootmgr
          efivar

          # file tools
          exfatprogs

          # maintenance tools
          btrfs-heatmap # btrfs usage visualization
          nvme-cli
          smartmontools
        ]
      )
      ++ (
        # network (linux-only)
        lib.optionals cfg.network [
          rustnet
        ]
      );
  };
}
