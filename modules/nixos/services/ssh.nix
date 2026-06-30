{
  config,
  lib,
  ...
}: let
  cfg = config.hex.nixos.services.ssh;
in {
  services.openssh = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # TODO: use safer authentication methods
    };
  };
}
