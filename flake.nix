{
  description = "nixos-config";

  # 信任 fcitx5-vinput 的二进制缓存
  # make sure below is consistent w/ ./modules/shared/nix.nix
  nixConfig = {
    extra-substituters = ["https://fcitx5-vinput.cachix.org"];
    extra-trusted-public-keys = ["fcitx5-vinput.cachix.org-1:XpX3AA6+dDIX4qJhb1QM7sbTwX6/qSlGvW8Z5NK6XdU="];
  };

  inputs = {
    # base os
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    # extra packages
    nur = {
      url = "github:nix-community/NUR"; # unused: reserved for future use
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
    monique = {
      url = "github:ToRvaLDz/monique";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fcitx5-vinput = {
      url = "github:xifan2333/fcitx5-vinput";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix"; # TODO: add precommit checks
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
    monique,
    fcitx5-vinput,
    ...
  }: let
  in {
    packages = let
      mkPkgs = system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        hyprglass = pkgs.callPackage ./packages/hyprglass.nix {};
        hypr-kinetic-scroll = pkgs.callPackage ./packages/hypr-kinetic-scroll.nix {};
        hyprexpo = pkgs.callPackage ./packages/hyprexpo.nix {};
        jhentai = pkgs.callPackage ./packages/jhentai.nix {};
      };
    in {
      x86_64-linux = mkPkgs "x86_64-linux";
      aarch64-darwin = {jhentai = (mkPkgs "aarch64-darwin").jhentai;};
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
          inherit self nixos-wsl home-manager monique;
        };
        system = "x86_64-linux";
        modules = [
          ./hosts/wsl/default.nix
        ];
      };

      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self home-manager disko nixos-hardware noctalia nix-cavalry monique fcitx5-vinput;
        };
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/thinkpad/default.nix
        ];
      };

      vmware = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self home-manager disko noctalia monique;
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
