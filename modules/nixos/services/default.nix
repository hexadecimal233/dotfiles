{
  lib,
  config,
  ...
}: {
  imports = [
    ./ssh.nix
    ./fail2ban.nix
    ./virtualization.nix
  ];

  options.hex.nixos.services = {
    ssh.enable = lib.mkEnableOption "OpenSSH server";
    fail2ban.enable = lib.mkEnableOption "Fail2Ban intrusion prevention";
    virtualization.enable = lib.mkEnableOption "Docker and Docker Compose";
  };
}
