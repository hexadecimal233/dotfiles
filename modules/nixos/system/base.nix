# NixOS base system: user account, locale, shell, scripts
{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  cfg = config.hex.nixos.system;
in {
  config = lib.mkIf cfg.enable {
    users.users.hexzii = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # root access
        "networkmanager" # wired/wireless mgmt
        "audio" # audio mgmt
        "video" # gpu access
        # "input"
        "jackaudio"
        "dialout" # external serial bus
        "docker" # docker mgmt
      ];
      shell = pkgs.fish;
      initialPassword = "123456";
    };

    # console.font = "LatArCyrHeb-16"; @ tty does not support cn font

    # "en_US.UTF-8";
    i18n.defaultLocale = "zh_CN.UTF-8"; # TODO: split form this file

    programs.fish.enable = true;
    programs.nix-ld.enable = true;

    programs.nix-ld.libraries = with pkgs; [
      libGL
      glib
      icu # FIXME: some dotnet program does not work
    ];

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "sudo-proxy" (builtins.readFile (self + "/scripts/sudo-proxy.sh")))
      (writeShellScriptBin "escape" (builtins.readFile (self + "/scripts/escape.sh")))
      (writeShellScriptBin "opencode-workspace" (builtins.readFile (self + "/scripts/opencode-workspace.sh")))
      (writeScriptBin "set-chezmoi-dir" (builtins.readFile (self + "/scripts/set-chezmoi-dir.nu")))
    ];
  };
}
