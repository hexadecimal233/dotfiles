# Nix package manager settings (cross-platform)
{
  lib,
  config,
  ...
}: let
  cfg = config.hex.shared.nix;
in {
  options.hex.shared.nix = {
    enable = lib.mkEnableOption "Nix package manager settings (GC, flakes, etc.)";
  };

  config = lib.mkIf cfg.enable {
    nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];
    nix.gc = {
      automatic = true;
      #  per-system timer are handled separately
      options = "--delete-older-than 7d";
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "aseprite"
        "cavalry"
        "reaper"
        "bitwig-studio"
        ""
      ];
  };
}
