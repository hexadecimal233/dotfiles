# Power management (UPower, TLP/PPD/TuneD, powertop)
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

    daemon = lib.mkOption {
      type = lib.types.enum ["ppd" "tlp" "tuned"];
      default = "ppd";
      description = "Power management daemon: ppd (power-profiles-daemon), tlp, or tuned.";
    };

    tlp = {
      pd = {
        enable = lib.mkEnableOption "TLP's power-profiles-daemon compat (replaces PPD)" // {default = false;};
      };
    };

    tuned = {};
  };

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;

    # Only the selected daemon runs; disable the others
    # (nixos-hardware has a fallback enabling TLP when PPD is off — override it)
    services.power-profiles-daemon.enable = cfg.daemon == "ppd";

    services.tlp =
      { enable = cfg.daemon == "tlp"; }
      // lib.optionalAttrs (cfg.daemon == "tlp") {
        pd.enable = cfg.tlp.pd.enable;
        settings = {
          START_CHARGE_THRESH_BAT0 = 40;
          STOP_CHARGE_THRESH_BAT0 = 80;
        };
      };

    # TuneD — richer profiles, provides PPD compat via ppdSupport
    # No hardcoded recommend: TuneD auto-detects hardware and remembers last selection
    services.tuned = lib.mkIf (cfg.daemon == "tuned") {
      enable = true;
      ppdSupport = true; # provides PPD D-Bus interface for Noctalia/powerprofilesctl
    };

    # CPU frequency scaling governor
    powerManagement.enable = true;

    # powerprofilesctl CLI needed for Noctalia integration;
    # when using tuned, the PPD package is still installed for the CLI tool
    # (it talks to tuned-ppd's D-Bus compat interface)
    environment.systemPackages = with pkgs;
      [powertop] # power consumption analysis on intel devices
      ++ lib.optionals (cfg.daemon == "tuned") [power-profiles-daemon];
  };
}
