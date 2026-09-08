# Linux-only system fonts: fills gaps macOS ships natively (CJK, emoji, metric-compatible)
# Maple Mono (the essential cross-platform mono) stays in modules/shared/desktop/fonts.nix
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.desktop.fonts;
in {
  options.hex.nixos.desktop.fonts = {
    enable = lib.mkEnableOption "system fonts (CJK/emoji/liberation fills)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      # noto series
      noto-fonts
      source-han-sans
      source-han-serif
      source-han-mono
      noto-fonts-color-emoji

      # user-specified
      lxgw-wenkai # 楷体 font
      liberation_ttf # windows font drop-in replacement

      # mono font (non-essential; Maple Mono is the primary mono)
      # fira-code
      jetbrains-mono
      nerd-fonts.jetbrains-mono # patched jb-mono
    ];
  };
}
