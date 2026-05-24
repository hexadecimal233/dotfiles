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
    options = "--delete-older-than 7d";
  };

  environment.systemPackages = with pkgs; [
    # system tools
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
    zip
    unzip
    # efibootmgr

    # utils
    bc
    alejandra
    ffmpeg
    yt-dlp

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

  # Zsh 设为用户默认 shell
  programs.zsh.enable = true;
  users.users.hexzii.shell = pkgs.zsh;

  system.stateVersion = "25.11";
}
