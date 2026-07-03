{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./dev.nix
    ./editor.nix
    ./git.nix
    ./pgp.nix
    ./java.nix
    ./packages.nix
    ./shell.nix
  ];
}
