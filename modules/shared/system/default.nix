# cross-platform system tools
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.system;
in {
  imports = [
    ./tools.nix
  ];

  options.hex.shared.system = {
    enable = lib.mkEnableOption "core system (nix settings, environment)";
    tools.enable = lib.mkEnableOption "cross-platform system tools (htop, btop, wget, etc.)";
  };

  config = lib.mkIf cfg.enable {
    hex.shared.system.tools.enable = lib.mkDefault true;
  };
}
