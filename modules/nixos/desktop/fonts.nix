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
      # noto series
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # source series
      # source-han-sans
      # source-han-serif
      # source-han-mono

      # user-specified
      lxgw-wenkai # 楷体 font
      liberation_ttf # windows font drop-in replacement

      # emojis
      noto-fonts-color-emoji

      # mono font
      # fira-code
      jetbrains-mono
      nerd-fonts.jetbrains-mono # patched jb-mono
      maple-mono.NF-CN-unhinted # the mono font im using^^
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
