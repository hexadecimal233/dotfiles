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
      ];

      home.sessionVariables = {
        EDITOR = "vim";
        VISUAL = "vim";
      };

      home.stateVersion = "25.11";
    };
  };
}
