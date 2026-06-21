{
  self,
  pkgs,
  disko,
  nixos-hardware,
  nix-cavalry,
  ...
}: {
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14
    nixos-hardware.nixosModules.common-gpu-intel
    self.nixosModules.profile
    disko.nixosModules.disko
    ./disko-config.nix
    ./hardware-configuration.nix
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
      # networking.dae.enable = true;  # FIXME: broken build, re-enable when upstream fixes pnpmDepsHash
      wireless.enable = true;
      power.enable = true;
      time.auto = true;
      graphics.enable = true;
      ime.enable = true;
      ios.enable = true;
    };
    hex.shared.system = {
      enable = true;
      tools.enable = true;
    };
    hex.nixos.desktop = {
      enable = true;
      wm = "hyprland";
      audio = {
        enable = true;
        usePulse = false; # physical machine uses PipeWire
      };
      fonts.enable = true;
      proxy.clash.enable = true;
    };
    hex.shared.home.shell.enable = true;
    hex.shared.home.git.enable = true;
    hex.shared.home.editor.enable = true;
    hex.shared.home.dev = {
      enable = true;
      ai.enable = true;
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
      hosting = true;
    };
    hex.shared.home.gpg.enable = true;
    hex.shared.home.java.enable = true;
    hex.shared.home.java.legacy = true;
    hex.nixos.home.desktop = {
      enable = true;
      noctalia.enable = true;
      packages.enable = true;
      theme.enable = true;
      minecraft.enable = true;
      production.enable = true;
    };

    # host-specific proxy
    home-manager.users.hexzii.home.sessionVariables = {
      PROXY_DEFAULT = "http://localhost:7897";
    };

    # networking.hostName = "thinkpad";

    # TODO: move to kernal
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Intel GPU: xe driver with required firmware
    hardware.intelgpu.driver = "xe";
    hardware.enableRedistributableFirmware = true;

    services.btrfs.autoScrub.enable = true;
    nixpkgs.overlays = [
      nix-cavalry.overlays.default # TODO: do not use overlay way

      # TODO: remove this later
      # Patch hypr-dynamic-cursors: linear bezier for shake magnification
      # (final: prev: {
      #   hyprlandPlugins =
      #     prev.hyprlandPlugins
      #     // {
      #       hypr-dynamic-cursors = prev.hyprlandPlugins.hypr-dynamic-cursors.overrideAttrs (old: {
      #         patches = (old.patches or []) ++ ["${self}/packages/patches/hypr-dynamic-cursors/linear-bezier.patch"];
      #       });
      #     };
      # })
    ];

    home-manager.users.hexzii.home.packages = [
      pkgs.cavalry
    ];
  };
}
