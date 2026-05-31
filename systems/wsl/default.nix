{
  self,
  nixos-wsl,
  pkgs,
  # sops-nix,
  ...
}: {
  imports = [
    nixos-wsl.nixosModules.default
    # sops-nix.nixosModules.sops
    self.nixosModules.profile
  ];

  config = {
    # === 编排选项 ===
    hexzii.profile = {
      desktopInfra = true;
      home = true;
    };

    # WSL 下强制使用 PulseAudio（WSLg 提供 PA server）
    hexzii.desktop.infra.audio.usePulse = true;

    wsl.enable = true;
    wsl.defaultUser = "hexzii";
    wsl.useWindowsDriver = true; # enable windows gpu driver support
    wsl.wslConf.interop.appendWindowsPath = false; # prevent windows path lagging system down
    
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
