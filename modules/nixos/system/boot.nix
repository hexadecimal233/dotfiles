# GRUB bootloader configuration
{
  lib,
  config,
  ...
}: let
  cfg = config.hex.nixos.system.boot;
in {
  options.hex.nixos.system.boot = {
    enable = lib.mkEnableOption "GRUB bootloader (UEFI)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      /*
         use only if necessary!!
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev"; # UEFI: no specific device needed
      };
      */
      efi.canTouchEfiVariables = true;
    };
  };
}
