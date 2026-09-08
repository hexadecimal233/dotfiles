# Darwin system: nix daemon, fish shell, system packages
{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  cfg = config.hex.darwin.system;
in {
  options.hex.darwin.system = {
    enable = lib.mkEnableOption "darwin system (nix daemon, fish shell)";
  };

  config = lib.mkIf cfg.enable {
    # nix daemon
    nix.enable = true;

    # shell
    programs.fish.enable = true;
    environment.shells = [pkgs.fish]; # add fish to /etc/shells
    # don't forget to run sudo chsh -l /path/to/fish hexzii
  };
}
