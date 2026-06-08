{pkgs, ...}: {
  home.packages = with pkgs; [
    # system tools
    age
    sops
    gnupg
    chezmoi

    # data
    pv
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
    mediainfo
    yt-dlp

    # network
    whois
    asn

    # beautify
    # hollywood
    fastfetch
    hyfetch
  ];
}
