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
      monospace = ["Maple Mono NF CN"]; # 终端等宽字体
      sansSerif = ["Noto Sans CJK SC"]; # 无衬线字体（含中文）
      serif = ["Noto Serif CJK SC"]; # 衬线字体（含中文）
      emoji = ["Noto Color Emoji"]; # 表情符号字体
    };
  };
}
