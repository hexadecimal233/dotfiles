{
  self,
  pkgs,
  disko,
  nixos-hardware,
  ...
}: {
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14
    self.nixosModules.profile
    disko.nixosModules.disko
    ./disko-config.nix
  ];

  config = {
    # host identity
    system.stateVersion = "26.05"; # Did you read the comment — first install was 26.05

    home-manager.users.hexzii.home.stateVersion = "26.05";

    # hex options
    hex.system.enable = true;
    hex.desktop = {
      enable = true;
      audio = {
        enable = true;
        usePulse = false; # physical machine uses PipeWire
      };
      fonts.enable = true;
      hyprland.enable = true;
    };
    hex.shell.enable = true;
    hex.git.enable = true;
    hex.editor.enable = true;
    hex.dev.enable = true;
    hex.packages.enable = true;
    hex.gpg.enable = true;

    # ThinkPad-specific (not abstracted)
    boot.loader = {
      systemd-boot.enable = true;
      # 或者使用 GRUB（如果需要双系统，可以改用这个）
      # grub = {
      #   enable = true;
      #   efiSupport = true;
      #   efiInstallAsRemovable = true;
      #   device = "nodev";  # 对于 UEFI，device 设置为 "nodev"
      # };
      efi.canTouchEfiVariables = true;
    };

    networking.networkmanager.enable = true;

    # Power management
    services.tlp.enable = true;
    powerManagement.enable = true;

    # Bluetooth
    hardware.bluetooth.enable = true;

    # SSD TRIM
    services.fstrim.enable = true;

    # Fingerprint reader
    services.fprintd.enable = true;
    # TODO: PAM integration for fingerprint auth — add 'lib' to function args, then:
    #   security.pam.services.sudo.fprintAuth = lib.mkDefault true;
    #   security.pam.services.login.fprintAuth = lib.mkDefault true;  # may break GDM
  };
}
