{
  description = "nixos-config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    ...
  }: {
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {wsl = nixos-wsl;};
        system = "x86_64-linux";
        modules = [
          ./modules/wsl/default.nix
          # ./modules/desktop/default.nix
          ./configuration.nix
        ];
      };

      physical = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware-configuration.nix
          # ./modules/desktop/default.nix
          ./configuration.nix
        ];
      };
    };
  };
}
