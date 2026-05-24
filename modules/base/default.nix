# 基础系统配置：用户、时区、Nix 设置、系统级 shell、核心包
{pkgs, ...}: {
  imports = [
    ./programs
  ];

  system.stateVersion = "25.11";

  users.users.hexzii = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh; # set up user shell
  };

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  programs.zsh.enable = true; # use system shell
  programs.nix-ld.enable = true; # support for dynamically linked programs

  # ==================== 核心系统包 ====================
  environment.systemPackages = with pkgs; [
    # system tools
    wget
    curl
    rsync
    gnumake
    just
    jq
    # file tools
    zip
    unzip
    # utilities
    bc
    ffmpeg
    # sudo with proxy
    (writeShellScriptBin "sudo-proxy" (builtins.readFile ../../scripts/sudo-proxy.sh))
  ];
}
