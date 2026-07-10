# Fingerprint reader (fprintd)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.fingerprint;
in {
  options.hex.nixos.system.fingerprint = {
    enable = lib.mkEnableOption "fingerprint reader (fprintd)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
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
