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
      # dj / audio software
      mixxx
      spek
      friture # TODO: broken on wayland
      polyphone

      # graphics
      blender
      # vengi-tools # outdate
      upscayl
      radiance-vj

      # the nostalgic trackers
      ft2-clone
      schismtracker # TODO: latest ver
      furnace
      famistudio

      # daws / audio
      vmpk
      audacity
      # vcv-rack
      # TODO: try reaper

      # TODO: crossplatform vsts
      # yabridge
      # yabridgectl # cli

      # painting / designing
      gimp
      krita
      inkscape
      # aseprite FIXME: failed build
    ];
  };
}
