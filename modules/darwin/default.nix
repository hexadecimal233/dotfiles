# Orchestration: imports all hex.* modules (darwin)
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

    # shared (cross-platform, system)
    ../shared/system
    # darwin (system-level)
    ./system.nix
    ./system/fonts.nix
  ];
}
