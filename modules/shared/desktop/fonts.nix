# Cross-platform font: Maple Mono (essential — terminals/editors render with it)
# Linux-specific fills (CJK/emoji/liberation) live in modules/nixos/desktop/fonts.nix
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.desktop.fonts;
in {
  options.hex.shared.desktop.fonts = {
    enable = lib.mkEnableOption "Maple Mono font (cross-platform)";
  };

  config = lib.mkIf (config.hex.shared.desktop.enable && cfg.enable) {
    fonts.packages = with pkgs; [
      maple-mono.NF-CN-unhinted # the mono font im using^^
    ];
  };
}
