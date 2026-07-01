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
    self.nixosModules.nixos
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
      power = {
        enable = true;
        daemon = "tuned"; # replaces power-profiles-daemon
      };
      time.auto = true;
      graphics.enable = true;
      ime.enable = true;
      mobile.enable = true;
    };
    hex.shared.system = {
      enable = true;
      tools.enable = true;
    };
    hex.nixos.desktop = {
      base.enable = true;
      wm = "hyprland";
      audio = {
        enable = true;
        usePulse = false; # physical machine uses PipeWire
      };
      proxy.clash.enable = true;
      apps = {
        flatpak = true;
        appimage = true;
      };
    };
    hex.shared.desktop = {
      enable = true;
      fonts = {
        enable = true;
        source = true;
      };
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

    hex.nixos.services.tailscale.enable = true;
    hex.nixos.services.virtualization.enable = true;

    # host-specific proxy
    home-manager.users.hexzii.home.sessionVariables = {
      PROXY_DEFAULT = "http://localhost:7897";
    };

    # networking.hostName = "thinkpad";

    # Intel GPU: xe driver with required firmware
    hardware.intelgpu.driver = "xe";
    hardware.enableRedistributableFirmware = true;

    services.btrfs.autoScrub.enable = true;
    nixpkgs.overlays = [
      nix-cavalry.overlays.default # TODO: do not use overlay way

      # Override fsearch to build from latest commit
      (final: prev: {
        fsearch = prev.fsearch.overrideAttrs (old: {
          version = "unstable-2026-06-21";
          src = final.fetchFromGitHub {
            owner = "cboxdoerfer";
            repo = "fsearch";
            rev = "5056e2a67e88ba84b8bca990883ddb969e9678bb";
            hash = "sha256-+5fjI2oCCxTh2JOt+tsQ/r5e3nl5E4dod6isz+EebUQ=";
          };
          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [final.itstool];
        });
      })

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
