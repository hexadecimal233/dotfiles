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
    services.fprintd.enable = true;

    # pam sucks: they execute in order
    # security.pam.services = {
    # sudo.fprintAuth = true;
    # login.fprintAuth = true;
    # };
  };
}
