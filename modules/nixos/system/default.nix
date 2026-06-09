{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  cfg = config.hex.nixos;
in {
  imports = [
    ./tools.nix
  ];

  options.hex.nixos = {
    enable = lib.mkEnableOption "NixOS system (users, locale, nix settings)";
    tools.enable = lib.mkEnableOption "linux-only system tools (lshw, pciutils, etc.)";
  };

  config = lib.mkIf cfg.enable {
    hex.nixos.tools.enable = lib.mkDefault true;
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
      (writeShellScriptBin "sudo-proxy" (builtins.readFile (self + "/scripts/sudo-proxy.sh")))
    ];
  };
}
