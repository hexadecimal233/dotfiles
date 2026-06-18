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
      (
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
          lm_sensors
          efibootmgr
          efivar
          btrfs-heatmap # btrfs usage visualization
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
