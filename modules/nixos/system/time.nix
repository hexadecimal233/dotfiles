# Timezone management (manual or automatic via geoclue2)
{
  lib,
  config,
  ...
}: let
  cfg = config.hex.nixos.system.time;
in {
  options.hex.nixos.system.time = {
    auto = lib.mkEnableOption "automatic timezone via geoclue2 (automatic-timezoned)" // {default = false;};
    timezone = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "Asia/Shanghai";
      description = "Static timezone. null = keep UTC / don't manage.";
    };
  };

  config = lib.mkMerge [
    # Auto mode: geoclue2-based automatic timezone
    (lib.mkIf cfg.auto {
      services.automatic-timezoned.enable = true;
      services.geoclue2 = {
        enable = true;
        geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
      };
    })

    # Static mode: set a fixed timezone
    (lib.mkIf (cfg.timezone != null) {
      time.timeZone = cfg.timezone;
    })
  ];
}
