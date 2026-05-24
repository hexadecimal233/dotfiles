{pkgs, ...}: {
  home.packages = with pkgs; [
    # 系统工具 — 用户级别
    tmux
    gnupg
    sops
    uv
    zsh
    bat

    # 工具
    starship
    eza
    ripgrep
    fd
    fzf
    yt-dlp

    # 美化
    fastfetch
    hyfetch
  ];

  programs.bat = {
    enable = true;
  };
}
