{pkgs, ...}: {
  home.packages = with pkgs; [
    # system tools
    sops # todo: configure secrets
    gnupg

    # data
    bc
    jq
    yq

    # file tools
    ouch
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

    # network
    pv
    whois

    # beautify
    hollywood
    fastfetch
    hyfetch
  ];
}
