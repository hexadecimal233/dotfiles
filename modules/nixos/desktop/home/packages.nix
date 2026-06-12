# Desktop GUI packages
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.home.desktop.packages;
in {
  options.hex.nixos.home.desktop.packages = {
    enable = lib.mkEnableOption "desktop GUI packages (ghostty, firefox, vesktop)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii.home.packages = with pkgs; [
      ghostty
      firefox
      vesktop
    ];
  };
}
