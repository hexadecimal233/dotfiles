# home-manager integration (darwin)
{home-manager, ...}: {
  imports = [
    home-manager.darwinModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
