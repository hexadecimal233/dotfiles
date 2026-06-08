{
  self,
  nixos-wsl,
  pkgs,
  ...
}: {
  imports = [
    nixos-wsl.nixosModules.default
    self.nixosModules.profile
  ];

  config = {
    # hex options
    hex.system.enable = true;
    hex.desktop = {
      enable = true;
      audio = {
        enable = true;
        usePulse = true; # WSL uses WSLg PulseAudio
      };
      fonts.enable = true;
      hyprland.enable = false; # WSL has no Hyprland
    };
    hex.shell.enable = true;
    hex.git.enable = true;
    hex.editor.enable = true;
    hex.dev.enable = true;
    hex.packages.enable = true;
    hex.gpg.enable = true;

    # WSL-specific (not abstracted, written directly)
    wsl.enable = true;
    wsl.defaultUser = "hexzii";
    wsl.useWindowsDriver = true; # enable windows gpu driver support
    wsl.wslConf.interop.appendWindowsPath = false; # prevent windows path lagging system down

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
