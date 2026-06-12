# Power management (UPower, TLP/PPD, powertop)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.power;
in {
  options.hex.nixos.system.power = {
    enable = lib.mkEnableOption "power management" // {default = false;};
    tlp = {
      enable = lib.mkEnableOption "TLP laptop power management (battery charge thresholds)" // {default = false;};
      pd = {
        enable = lib.mkEnableOption "TLP's power-profiles-daemon compat (replaces PPD)" // {default = false;};
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;

    # power-profiles-daemon (Noctalia power widget needs the D-Bus interface)
    # TLP + tlp-pd provides the same interface when enabled
    services.power-profiles-daemon.enable = lib.mkIf (!cfg.tlp.enable) true;

    # TLP — manages battery charge thresholds + optional tlp-pd
    services.tlp = lib.mkIf cfg.tlp.enable {
      enable = true;
      pd.enable = cfg.tlp.pd.enable;
      settings = {
        # Battery charge thresholds
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };

    # CPU frequency scaling governor
    powerManagement.enable = true;

    environment.systemPackages = with pkgs; [
      powertop # power consumption analysis on intel devices
    ];
  };
}
