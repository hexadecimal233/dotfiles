{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.services.virtualization;
in {
  environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [
    docker
    docker-compose
  ]);
  virtualisation.docker = lib.mkIf cfg.enable {
    enable = true;
  };
}
