# dev infrastructure tools
{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.hex.system.infra.enable {
    environment.systemPackages = with pkgs; [
      gnumake
      nh
      just
      docker-compose
      python3
    ];
  };
}
