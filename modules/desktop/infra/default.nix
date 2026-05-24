{...}: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./graphics.nix
  ];

  programs.dconf.enable = true;
}
