# Cross-platform font configuration
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.desktop.fonts;
in {
  options.hex.shared.desktop.fonts = {
    enable = lib.mkEnableOption "fonts";
    source = lib.mkEnableOption "Source Han (思源) font series";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.hex.shared.desktop.enable && cfg.enable) {
      fonts.packages = with pkgs;
        [
          # noto series
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-color-emoji

          # user-specified
          lxgw-wenkai # 楷体 font
          liberation_ttf # windows font drop-in replacement

          # mono font
          # fira-code
          jetbrains-mono
          nerd-fonts.jetbrains-mono # patched jb-mono
          maple-mono.NF-CN-unhinted # the mono font im using^^
        ]
        ++ lib.optionals cfg.source [
          # source series (思源字体) — enabled via fonts.source
          source-han-sans
          source-han-serif
          source-han-mono
        ];
    })
  ];
}
