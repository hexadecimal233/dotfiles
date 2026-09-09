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
      initialPassword = "123456"; # betterleaks:allow
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
  };
}
