{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hex.nixos.home.desktop.production;
in {
  options.hex.nixos.home.desktop.production = {
    enable = lib.mkEnableOption "production stuff" // {default = false;};
  };

  config = lib.mkIf (config.hex.nixos.home.desktop.enable && cfg.enable) {
    home-manager.users.hexzii.home.packages = with pkgs; [
      mixxx # DJ software
      ft2-clone
      schismtracker # TODO: latest ver
    ];
  };
}
