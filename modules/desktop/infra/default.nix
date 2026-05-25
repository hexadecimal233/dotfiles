{
  lib,
  config,
  ...
}: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./graphics.nix
  ];

  config = lib.mkIf config.hexzii.profile.desktopInfra {
    programs.dconf.enable = true;
  };
}
