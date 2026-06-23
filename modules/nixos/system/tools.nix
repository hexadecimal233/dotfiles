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
          perf
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
          fwupd

          # file tools
          exfatprogs

          # maintenance tools
          btrfs-heatmap # btrfs usage visualization
          nvme-cli
          smartmontools

          # dev infra (crossplatform)
          binutils
          valgrind
          gnumake
          gcc
          clang
          pkg-config
          lldb
          gdb

          # dev infra
          strace
          ltrace
        ]
      )
      ++ (
        # network (linux-only)
        lib.optionals cfg.network [
          rustnet
        ]
      );

    # fwupd service must be registered via NixOS module, not just the package
    services.fwupd.enable = lib.mkIf cfg.hardware true;
  };
}
