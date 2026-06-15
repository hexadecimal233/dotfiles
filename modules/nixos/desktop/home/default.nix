# Orchestration: imports all hex.nixos.home.desktop.* modules
{
  lib,
  config,
  ...
}: let
  cfg = config.hex.nixos.home.desktop;
in {
  imports = [
    ./minecraft.nix
    ./noctalia.nix
    ./packages.nix
    ./theme.nix
  ];

  options.hex.nixos.home.desktop = {
    enable = lib.mkEnableOption "NixOS-exclusive desktop home-manager modules";
  };
}
