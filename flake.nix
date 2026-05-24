{
  description = "nixos-config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {wsl = nixos-wsl;};
        system = "x86_64-linux";
        modules = [
          ./systems/wsl/default.nix
          # ./modules/desktop/default.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.hexzii = import ./modules/home;
            };
          }
        ];
      };
    };
  };
}
