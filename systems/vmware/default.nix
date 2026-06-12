{
  self,
  pkgs,
  disko,
  ...
}: {
  imports = [
    self.nixosModules.profile
    disko.nixosModules.disko
    ./disko-config.nix
  ];

  config = {
    # host identity
    # Set this to the nixpkgs release version used at first install.
    # nixpkgs-unstable as of 2025-06 = 25.11, 2026-06 = 26.05
    # Change only when explicitly upgrading nixpkgs channel.
    system.stateVersion = "26.05";

    home-manager.users.hexzii.home.stateVersion = "26.05";

    # hex options — explicitly opt-in, no assumptions
    hex.shared.nix.enable = true;

    # system (users, locale, nix settings)
    hex.nixos.system.enable = true;

    # desktop for VM testing — minimal Hyprland
    hex.nixos.desktop = {
      enable = true;
      audio.enable = true;
      fonts.enable = true;
      hyprland.enable = true;
    };

    # cross-platform tools
    hex.shared.system.enable = true;

    # home-manager modules — minimal set
    hex.shared.home.shell.enable = true;
    hex.shared.home.git.enable = true;
    hex.shared.home.editor.enable = true;
    hex.shared.home.dev.enable = true;
    hex.shared.home.packages.enable = true;

    # VM boot — adjust for your VMware setup (BIOS or UEFI)
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # VMware guest tools (mouse, clipboard, screen resize)
    virtualisation.vmware.guest.enable = true;

    # basic networking
    networking.networkmanager.enable = true;

    # host-specific proxy
    home-manager.users.hexzii.home.sessionVariables = {
      PROXY_DEFAULT = "http://localhost:7897";
    };

    # nixos platform
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
