{pkgs, ...}: {
  fonts.packages = with pkgs; [
    maple-mono.NF-CN-unhinted
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    fira-code
    liberation_ttf
  ];

  fonts.enableDefaultPackages = true; # fallback

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = ["Maple Mono NF CN"];
      sansSerif = ["Noto Sans CJK SC"];
      serif = ["Noto Serif CJK SC"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
