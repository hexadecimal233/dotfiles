{
  lib,
  home-manager,
  ...
}: {
  imports = [
    home-manager.darwinModules.home-manager

    ../shared

    ./system.nix

    ./virtualization.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
