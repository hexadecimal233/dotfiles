{home-manager, ...}: {
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.hexzii = {
      imports = [
        ./shell.nix
        ./git.nix
        ./gpg.nix
        ./packages.nix
        ./nvim.nix
      ];

      home.stateVersion = "25.11"; # home.stateVersion = osConfig.system.nixos.release
    };
  };
}
