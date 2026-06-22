# iOS device support (iPhone, iPad): libimobiledevice + usbmuxd + ifuse
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.mobile;
in {
  options.hex.nixos.system.mobile = {
    enable = lib.mkEnableOption "mobile device support (libimobiledevice, usbmuxd, ifuse, idevicerestore)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    services.usbmuxd.enable = true;

    environment.systemPackages = with pkgs; [
      # mtp
      android-file-transfer # better mtp

      # apple devices
      libimobiledevice # pairing, tethering, idevicepair
      ifuse # FUSE mount iOS device filesystem
      idevicerestore # DFU/recovery mode firmware restore
    ];
  };
}
