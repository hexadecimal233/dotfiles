{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.desktop.fonts;
in {
  config = lib.mkIf (config.hex.nixos.desktop.enable && cfg.enable) {
    fonts.packages = with pkgs; [
      maple-mono.NF-CN-unhinted # the mono font ^^
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # source-han-sans
      # source-han-serif
      noto-fonts-color-emoji
      # fira-code
      liberation_ttf
    ];

    fonts.enableDefaultPackages = true;

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
