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
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:xifan2333/fcitx5-vinput"; # do not use follows or cache will fail
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nasdots = {
      url = "github:daskladas/nasdots";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
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
    nasdots,
    ...
  } @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin"];

    # Pass all flake inputs to every host — modules declare what they need.
    mkNixosHost = {
      modules,
      system ? "x86_64-linux",
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs;
        modules = modules;
      };

    mkDarwinHost = {
      modules,
      system ? "aarch64-darwin",
    }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = inputs;
        modules = modules;
      };
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
      nixos = import ./modules/nixos;
    };

    darwinModules = {
      darwin = import ./modules/darwin;
    };

    nixosConfigurations = {
      wsl = mkNixosHost {
        modules = [
          ./hosts/wsl/default.nix
        ];
      };

      thinkpad = mkNixosHost {
        modules = [
          disko.nixosModules.disko
          ./hosts/thinkpad/default.nix
        ];
      };

      nixnas = mkNixosHost {
        modules = [
          ./hosts/nixnas/default.nix
        ];
      };
    };

    darwinConfigurations = {
      neo = mkDarwinHost {
        modules = [
          ./hosts/neo/default.nix
        ];
      };
    };

    formatter = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      pkgs.writeShellScriptBin "alejandra-wrapper" ''
        exec ${pkgs.alejandra}/bin/alejandra .
      '');
  };
}
