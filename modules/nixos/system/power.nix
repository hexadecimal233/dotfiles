# Power management (UPower, power-profiles-daemon, power tools)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.power;
in {
  options.hex.nixos.system.power = {
    enable = lib.mkEnableOption "power management (UPower, power-profiles-daemon)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;

    environment.systemPackages = with pkgs; [
      powertop # power consumption analysis
    ];
  };
}
