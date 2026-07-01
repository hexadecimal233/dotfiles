{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.services.ddns-go;
in {
  options.hex.nixos.services.ddns-go = {
    enable = lib.mkEnableOption "ddns-go dynamic DNS client" // {default = false;};

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Path to ddns-go configuration file. Defaults to .ddns_go_config.yaml
        under the service user's home directory. The config is auto-generated
        via the web UI at port 9876 on first run.
      '';
    };

    interval = lib.mkOption {
      type = lib.types.int;
      default = 300;
      description = "Sync interval in seconds (default: 300 = 5 minutes). Pass 0 to use ddns-go's default.";
    };

    listen = lib.mkOption {
      type = lib.types.str;
      default = ":9876";
      description = "Web UI listen address (default: :9876). Set to a specific IP for restricted access.";
    };

    enableWeb = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the web configuration UI. Disable with -noweb after initial setup.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ddns-go];

    systemd.services.ddns-go = {
      description = "ddns-go Dynamic DNS Client";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStart =
          "${pkgs.ddns-go}/bin/ddns-go"
          + " -l ${cfg.listen}"
          + " -f ${toString cfg.interval}"
          + lib.optionalString (!cfg.enableWeb) " -noweb"
          + lib.optionalString (cfg.configFile != null) " -c ${cfg.configFile}";
        Restart = "on-failure";
        RestartSec = "10s";
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "ddns-go";
      };
    };
  };
}
