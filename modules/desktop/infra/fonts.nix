{pkgs, ...}: {
  fonts.packages = with pkgs; [
    maple-mono.NF-CN-unhinted
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    # source-han-sans
    # source-han-serif
    noto-fonts-color-emoji
    # fira-code
    liberation_ttf
  ];

  fonts.enableDefaultPackages = true; # fallback

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = ["Maple Mono NF CN"];
      emoji = ["Noto Color Emoji"];
      sansSerif = ["Noto Sans CJK SC"];
      serif = ["Noto Serif CJK SC"];
    };
  };
}
