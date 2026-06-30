{
  config,
  lib,
  ...
}: let
  cfg = config.hex.nixos.services.fail2ban;
in {
  services.fail2ban = lib.mkIf cfg.enable {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      maxtime = "48h";
    };
    jails.sshd = {
      settings = {
        enabled = true;
        port = "ssh";
        filter = "sshd";
        maxretry = 5;
      };
    };
  };
}
