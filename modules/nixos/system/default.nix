{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.system;
in {
  imports = [
    ./tools.nix
    ./infra.nix
  ];

  options.hex.system = {
    enable = lib.mkEnableOption "core system (users, locale, nix settings)";
    tools.enable = lib.mkEnableOption "system-level tools (htop, btop, wget, etc.)";
    infra.enable = lib.mkEnableOption "dev infrastructure (gnumake, nh, just, docker-compose)";
  };

  config = lib.mkIf cfg.enable {
    hex.system.tools.enable = lib.mkDefault true;
    hex.system.infra.enable = lib.mkDefault true;
    users.users.hexzii = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.fish;
    };

    i18n.defaultLocale = "zh_CN.UTF-8";

    nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    programs.fish.enable = true;
    # FIXME: nix-ld enabled but no packages used yet
    programs.nix-ld.enable = true;
    services.vnstat.enable = true;

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "sudo-proxy" (builtins.readFile ../../../scripts/sudo-proxy.sh))
    ];
  };
}
