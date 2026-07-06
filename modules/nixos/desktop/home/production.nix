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
      # dj software
      mixxx

      # graphics
      blender
      radiance-vj
      qlcplus # outdated tho but wanna try it

      # the nostalgic trackers
      ft2-clone
      schismtracker # TODO: latest ver
      furnace
      famistudio

      # daws / audio
      vmpk
      audacity
      # TODO: try reaper

      # TODO: crossplatform vsts
      # yabridge
      # yabridgectl # cli

      # painting / designing
      gimp
      krita
      inkscape
      aseprite
    ];
  };
}
