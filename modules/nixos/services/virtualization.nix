{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hex.nixos.services.virtualization = {
    enable = lib.mkEnableOption "Docker and Docker Compose" // {default = false;};
  };

  config = lib.mkIf config.hex.nixos.services.virtualization.enable {
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
    ];

    virtualisation.docker = {
      enable = true;
    };
  };
}
