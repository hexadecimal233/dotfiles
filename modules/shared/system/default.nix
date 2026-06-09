# cross-platform system tools
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.system;
in {
  imports = [
    ./tools.nix
  ];

  options.hex.system = {
    enable = lib.mkEnableOption "core system (nix settings, environment)";
    tools.enable = lib.mkEnableOption "cross-platform system tools (htop, btop, wget, etc.)";
  };

  config = lib.mkIf cfg.enable {
    hex.system.tools.enable = lib.mkDefault true;
  };
}
