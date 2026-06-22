# NixOS-specific font settings (fontconfig, default packages)
{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.hex.nixos.desktop.enable {
    fonts.enableDefaultPackages = true; # basic linux fonts
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Maple Mono NF CN"];
        emoji = ["Noto Color Emoji"];
        sansSerif = ["Noto Sans CJK SC"];
        serif = ["Noto Serif CJK SC"];
      };
    };
  };
}
