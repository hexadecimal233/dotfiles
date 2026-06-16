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
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
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
    sops-nix = {
      url = "github:Mic92/sops-nix"; # unused: reserved for future use
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cavalry = {
      url = "github:hexadecimal233/nix-cavalry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-virtual-desktops = {
      url = "github:levnikmyskin/hyprland-virtual-desktops";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    nix-darwin,
    home-manager,
    disko,
    nixos-hardware,
    nix-cavalry,
    noctalia,
    hyprland-virtual-desktops,
    ...
  }: let
  in {
    packages = let
      mkPkgs = system: let pkgs = nixpkgs.legacyPackages.${system};
      in {
        hyprglass = pkgs.callPackage ./packages/hyprglass.nix {};
        hypr-kinetic-scroll = pkgs.callPackage ./packages/hypr-kinetic-scroll.nix {};
        hyprbars = pkgs.callPackage ./packages/hyprbars.nix {};
        jhentai = pkgs.callPackage ./packages/jhentai.nix {};
      };
    in {
      x86_64-linux = mkPkgs "x86_64-linux";
      aarch64-darwin = { jhentai = (mkPkgs "aarch64-darwin").jhentai; };
    };

    nixosModules = {
      profile = import ./modules/profile;
    };

    darwinModules = {
      profile = import ./modules/darwin;
    };

    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self nixos-wsl home-manager;
        };
        system = "x86_64-linux";
        modules = [
          ./hosts/wsl/default.nix
        ];
      };

      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self home-manager disko nixos-hardware noctalia nix-cavalry hyprland-virtual-desktops;
        };
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/thinkpad/default.nix
        ];
      };

      vmware = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self home-manager disko noctalia;
        };
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/vmware/default.nix
        ];
      };
    };

    darwinConfigurations = {
      neo = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit self nix-darwin home-manager;
        };
        system = "aarch64-darwin";
        modules = [
          ./hosts/neo/default.nix
        ];
      };
    };
  };
}
