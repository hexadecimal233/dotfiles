{
  description = "nixos-config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      # inputs.nix-darwin.follows = "nix-darwin";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    sops-nix,
    home-manager,
    ...
  }: {
    nixosModules = {
      profile = import ./modules/profile;
    };

    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self nixos-wsl home-manager sops-nix;
        };
        system = "x86_64-linux";
        modules = [
          ./systems/wsl/default.nix
        ];
      };
    };
  };
}
