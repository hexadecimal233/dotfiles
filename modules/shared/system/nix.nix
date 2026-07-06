# Nix package manager settings (cross-platform)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.nix;
in {
  options.hex.shared.nix = {
    enable = lib.mkEnableOption "Nix package manager settings (GC, flakes, etc.)";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes" "pipe-operators"];
        trusted-users = ["root" "hexzii"];
      };
      gc =
        {
          automatic = true;
          options = "--delete-older-than 7d";
        }
        // (
          # per-system timer are handled separately
          if pkgs.stdenv.isDarwin
          then {
            interval = {Weekday = 0;}; # launchd timers
          }
          else {
            dates = "weekly"; # systemd timers
          }
        );
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "aseprite"
        "cavalry"
        "reaper"
        "bitwig-studio"
        "jetbrains-toolbox"
        "warp-terminal"
        "unrar"
        "7zip-zstd"
        "uasm" # 7zip rar need this
        "ouch"
      ];
  };
}
