# Orchestration: imports all hex.* modules
{lib, ...}: {
  imports = [
    # home-manager
    ./home.nix

    # shared (cross-platform, home-manager)
    ../shared/home/shell.nix
    ../shared/home/git.nix
    ../shared/home/editor.nix
    ../shared/home/dev.nix
    ../shared/home/packages.nix
    ../shared/home/gpg.nix

    # nixos (system-level)
    ../nixos/system
    ../nixos/desktop
  ];
}
