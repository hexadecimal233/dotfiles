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
    nixosModules = {
      # 基础系统配置：用户、时区、Nix 设置、核心包
      base = import ./modules/base;

      # 桌面基础设施：音频、字体
      desktop-infra = import ./modules/desktop/infra;

      # 桌面应用
      desktop-apps = import ./modules/desktop/apps;

      # Home-manager 用户环境
      home = import ./modules/home;
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
