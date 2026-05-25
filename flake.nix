{
  description = "nixos-config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixosModules = {
      profile = import ./modules/profile;
    };

    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self nixos-wsl home-manager;
        };
        system = "x86_64-linux";
        modules = [
          ./systems/wsl/default.nix
        ];
      };
    };
  };
}
