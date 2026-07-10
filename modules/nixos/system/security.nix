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

    # unsuck fingerprint, we just don't enable fprintd
    # and do not let 'em take over, because they are not secure and
    # easy to abuse
    # TODO: remove this after hardware based auth is enabled on linux
    services.fprintd.enable = false;
    security.pam.services = {
      sudo.fprintAuth = false;
      login.fprintAuth = false;
    };
  };
}
