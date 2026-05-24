{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.hexzii = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
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
    just
    jq

    # infra tools
    git
    vim
    gh
    docker-compose
    nodejs_24

    # file tools
    zip
    unzip
    # efibootmgr

    # devel
    alejandra
    nixd

    # utils
    bc
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

    # sudo with proxy
    (writeShellScriptBin "sudo-proxy" (builtins.readFile ./scripts/sudo-proxy.sh))
  ];

  # Zsh 设为用户默认 shell
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  system.stateVersion = "25.11";
}
