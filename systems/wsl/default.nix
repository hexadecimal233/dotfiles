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
    # host identity
    system.stateVersion = "25.11"; # Did you read the comment?

    home-manager.users.hexzii.home.stateVersion = "25.11";

    # hex options
    hex.shared.nix.enable = true;
    hex.nixos.system.enable = true;
    hex.shared.system.enable = true;
    hex.nixos.desktop = {
      enable = true;
      audio = {
        enable = true;
        usePulse = true; # WSL uses WSLg PulseAudio
      };
      fonts.enable = true;
      hyprland.enable = false; # WSL has no Hyprland
    };
    hex.shared.home.shell.enable = true;
    hex.shared.home.git.enable = true;
    hex.shared.home.editor.enable = true;
    hex.shared.home.dev.enable = true;
    hex.shared.home.packages.enable = true;
    hex.shared.home.gpg.enable = true;

    # host-specific proxy
    home-manager.users.hexzii.home.sessionVariables = {
      PROXY_DEFAULT = "http://192.168.2.149:10808";
    };

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
