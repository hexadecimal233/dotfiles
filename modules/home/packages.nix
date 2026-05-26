{pkgs, ...}: {
  home.packages = with pkgs; [
    # system tools
    age
    sops
    gnupg

    # data
    bc
    jq
    yq

    # file tools
    ouch
    yazi
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
