{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  cfg = config.hex.darwin;
in {
  options.hex.darwin = {
    enable = lib.mkEnableOption "darwin system (nix daemon, fish shell)";
  };

  config = lib.mkIf cfg.enable {
    # nix daemon & settings
    nix.enable = true;
    nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];
    nix.gc = {
      automatic = true;
      interval = [{Weekday = 0;}]; # weekly (Sunday)
      options = "--delete-older-than 7d";
    };

    # shell
    programs.fish.enable = true;

    # system packages (darwin-safe)
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "sudo-proxy" (builtins.readFile (self + "/scripts/sudo-proxy.sh")))
    ];
  };
}
