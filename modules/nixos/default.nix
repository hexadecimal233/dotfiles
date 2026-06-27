{
  config,
  pkgs,
  home-manager,
  ...
}: {
  imports = [
    home-manager.nixosModules.home-manager

    ../shared
    ./system
    ./desktop
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
