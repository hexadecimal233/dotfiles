# System security (polkit, policies)
{
  lib,
  config,
  ...
}: let
  cfg = config.hex.nixos.system.security;
in {
  options.hex.nixos.system.security = {
    enable = lib.mkEnableOption "system security (polkit)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    # polkit — required by Noctalia's native auth agent
    security.polkit.enable = true;
  };
}
