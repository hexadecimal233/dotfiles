# iOS device support (iPhone, iPad): libimobiledevice + usbmuxd + ifuse
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.ios;
in {
  options.hex.nixos.system.ios = {
    enable = lib.mkEnableOption "iOS device support (libimobiledevice, usbmuxd, ifuse, idevicerestore)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    services.usbmuxd.enable = true;

    environment.systemPackages = with pkgs; [
      libimobiledevice  # pairing, tethering, idevicepair
      ifuse             # FUSE mount iOS device filesystem
      idevicerestore    # DFU/recovery mode firmware restore
    ];
  };
}
