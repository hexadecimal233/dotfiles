{
  config,
  lib,
  ...
}: {
  options.hex.nixos.services.fail2ban = {
    enable = lib.mkEnableOption "Fail2Ban intrusion prevention" // {default = false;};
  };

  config = lib.mkIf config.hex.nixos.services.fail2ban.enable {
    services.fail2ban = {
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
  };
}
