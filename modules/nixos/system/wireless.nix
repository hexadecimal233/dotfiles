# Wireless devices (Bluetooth)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.wireless;
in {
  options.hex.nixos.system.wireless = {
    enable = lib.mkEnableOption "wireless devices (wifi / bluetooth)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = false; # or maybe true

    environment.systemPackages = with pkgs; [
      bluez # bluetoothctl, etc.
      wavemon
    ];
  };
}
