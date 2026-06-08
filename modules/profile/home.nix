# home-manager integration
{home-manager, ...}: {
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.hexzii = {
      home.stateVersion = "25.11";
    };
  };
}
