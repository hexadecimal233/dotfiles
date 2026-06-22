# cross-platform system tools
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.system;
in {
  imports = [
    ./tools.nix
    ./nix.nix
  ];

  options.hex.shared.system = {
    enable = lib.mkEnableOption "core system (nix settings, environment)";
    tools.enable = lib.mkEnableOption "cross-platform system tools (htop, btop, wget, etc.)";
  };

  config = lib.mkIf cfg.enable {
    hex.shared.system.tools.enable = lib.mkDefault false;

    # sessionVariables only works on linux during the whole session
    # variables only take effect in shell sessions.
    environment.variables = {
      # disable telemetry
      OMO_DISABLE_POSTHOG = "1"; # oh-my-openagent
      OMO_SEND_ANONYMOUS_TELEMETRY = "0";
      ASTRO_TELEMETRY_DISABLED = "1"; # astro
    };
  };
}
