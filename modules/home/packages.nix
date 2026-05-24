{pkgs, ...}: {
  home.packages = with pkgs; [
    # system tools
    tmux
    sops # todo: configure secrets
    gnupg
    uv # added

    # data
    bc
    jq
    yq

    # file tools
    hexyl
    lnav
    ncdu
    file
    eza
    bat
    ripgrep
    fd
    fzf

    # utils
    ffmpeg
    yt-dlp

    # development
    gh
    alejandra

    # network
    pv
    whois

    # beautify
    hollywood
    fastfetch
    hyfetch
  ];
}
