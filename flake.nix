{
  description = "nixos-config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR"; # unused: reserved for future use
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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    denix = {
      url = "github:yunfachi/denix"; # unused: reserved for future use
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix"; # unused: reserved for future use
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    home-manager,
    disko,
    nixos-hardware,
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

      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self home-manager disko nixos-hardware;
        };
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./systems/thinkpad/default.nix
        ];
      };
    };
  };
}
