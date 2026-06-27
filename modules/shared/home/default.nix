{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./dev.nix
    ./editor.nix
    ./git.nix
    ./gpg.nix
    ./java.nix
    ./packages.nix
    ./shell.nix
  ];
}
