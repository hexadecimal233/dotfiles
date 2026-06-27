# Cross-platform desktop modules (fonts, etc.)
{lib, ...}: let
in {
  imports = [
    ./fonts.nix
  ];

  options.hex.shared.desktop = {
    enable = lib.mkEnableOption "cross-platform desktop environment";
  };
}
