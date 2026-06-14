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

    # Darwin-specific GC schedule (launchd format)
    nix.gc.interval = [{Weekday = 0;}]; # weekly (Sunday)

    # shell
    programs.fish.enable = true;
    environment.shells = [pkgs.fish]; # add fish to /etc/shells
    # don't forget to run sudo chsh -l /path/to/fish hexzii

    # system packages (darwin-safe)
    environment.systemPackages = with pkgs;
      [
        (writeShellScriptBin "sudo-proxy" (builtins.readFile (self + "/scripts/sudo-proxy.sh")))
        (writeShellScriptBin "set-chezmoi-dir" (builtins.readFile (self + "/scripts/set-chezmoi-dir.sh")))
        (writeShellScriptBin "escape" (builtins.readFile (self + "/scripts/escape.sh")))
        (writeShellScriptBin "unquarantine" (builtins.readFile (self + "/scripts/unquarantine.sh")))
      ]
      ++ [
        (pkgs.callPackage (self + "/modules/darwin/apps/jhentai.nix") {})
      ];
  };
}
