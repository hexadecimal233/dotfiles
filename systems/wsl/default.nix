{
  self,
  nixos-wsl,
  pkgs,
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
    wsl.useWindowsDriver = true; # enable windows gpu driver support

    hardware.graphics = {
      enable = true;
      enable32Bit = true; # 32 位兼容（Wine 什么的）
    };

    # fixes WSLg libd3d12.so and NVIDIA WSL driver libssl.so deps
    environment.sessionVariables = let
      wslGpuLibs = "/run/opengl-driver/lib";
      opensslLib = "${pkgs.openssl.out}/lib";
    in {
      LD_LIBRARY_PATH = "${wslGpuLibs}:${opensslLib}";
      GALLIUM_DRIVER = "d3d12";
      MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia"; # use dedicated gpu
    };
  };
}
