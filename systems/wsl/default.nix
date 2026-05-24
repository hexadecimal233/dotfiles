# WSL 系统实例
# 通过 self.nixosModules 统一引用，避免散乱的相对路径导入
{
  self,
  nixos-wsl,
  ...
}: {
  imports = [
    nixos-wsl.nixosModules.default
    self.nixosModules.base
    self.nixosModules.home
    self.nixosModules.desktop-infra
  ];

  config = {
    wsl.enable = true;
    wsl.defaultUser = "hexzii";
    wsl.useWindowsDriver = true;
    # FIXME: why tf gpu rendering does not work
  };
}
