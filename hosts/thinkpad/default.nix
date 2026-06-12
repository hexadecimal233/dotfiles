{
  self,
  pkgs,
  disko,
  nixos-hardware,
  ...
}: {
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14
    nixos-hardware.nixosModules.common-gpu-intel
    self.nixosModules.profile
    disko.nixosModules.disko
    ./disko-config.nix
  ];

  config = {
    # host identity
    system.stateVersion = "26.05"; # Did you read the comment — first install was 26.05

    home-manager.users.hexzii.home.stateVersion = "26.05";

    # hex options
    hex.shared.nix.enable = true;
    hex.nixos.system = {
      enable = true;
      tools = {
        enable = true;
        monitoring = true;
        hardware = true;
        network = true;
      };
      boot.enable = true;
      fingerprint.enable = true;
      security.enable = true;
      networking.enable = true;
      wireless.enable = true;
      power.enable = true;
      graphics.enable = true;
    };
    hex.shared.system = {
      enable = true;
      tools.enable = true;
    };
    hex.nixos.desktop = {
      enable = true;
      audio = {
        enable = true;
        usePulse = false; # physical machine uses PipeWire
      };
      fonts.enable = true;
      hyprland.enable = true;
    };
    hex.shared.home.shell.enable = true;
    hex.shared.home.git.enable = true;
    hex.shared.home.editor.enable = true;
    hex.shared.home.dev = {
      enable = true;
      nodejs.enable = true;
    };
    hex.shared.home.packages = {
      enable = true;
      systemTools = true;
      dataProcessing = true;
      fileTools = true;
      mediaUtils = true;
      network = true;
      beautify = true;
    };
    hex.shared.home.gpg.enable = true;
    hex.nixos.home.desktop = {
      enable = true;
      noctalia.enable = true;
      packages.enable = true;
    };

    # host-specific proxy
    home-manager.users.hexzii.home.sessionVariables = {
      PROXY_DEFAULT = "http://localhost:7897";
    };

    # Use latest kernel for Xe driver fixes (Linux 7.0)
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Intel GPU: xe driver with required firmware
    hardware.intelgpu.driver = "xe";
    hardware.enableRedistributableFirmware = true;

    # Laptop-specific power (not in power module)
    services.tlp.enable = true;
    powerManagement.enable = true;

    # SSD TRIM
    services.fstrim.enable = true;
  };
}
