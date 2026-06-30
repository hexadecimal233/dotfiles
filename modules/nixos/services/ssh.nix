{
  config,
  lib,
  ...
}: {
  options.hex.nixos.services.ssh = {
    enable = lib.mkEnableOption "OpenSSH server" // {default = false;};
  };

  config = lib.mkIf config.hex.nixos.services.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true; # TODO: use safer authentication methods
      };
    };
  };
}
