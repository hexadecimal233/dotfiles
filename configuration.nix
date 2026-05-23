{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.hexzii = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  environment.systemPackages = with pkgs; [
    # system tools
    zoxide
    tmux
    wget
    curl
    rsync
    gnumake
    jq

    # infra tools
    git
    vim
    gh
    docker-compose

    # file tools
    fzf
    ripgrep
    eza
    fd
    zip
    unzip
    # efibootmgr

    # utils
    bc
    alejandra
    starship
    ffmpeg
    yt-dlp

    # cool stuff
    fastfetch
    hyfetch

    # system monitoring
    powertop
    htop
    btop
    iotop
    lsof
    lshw
    pciutils
    usbutils
    dmidecode
    lm_sensors

    # networking
    ethtool
    iperf3
  ];

  system.stateVersion = "25.11";
}
