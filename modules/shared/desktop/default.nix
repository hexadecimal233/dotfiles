# Cross-platform desktop modules (fonts, etc.)
{
  lib,
  config,
  ...
}: let
  cfg = config.hex.shared.desktop;
in {
  imports = [
    ./fonts.nix
  ];

  options.hex.shared.desktop = {
    enable = lib.mkEnableOption "cross-platform desktop environment";
  };
}
