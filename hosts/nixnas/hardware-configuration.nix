{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "ahci" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = ["md_mod" "raid1"];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  boot.swraid.enable = true;
  boot.swraid.mdadmConf = ''
    MAILADDR root@localhost
  '';
  fileSystems."/boot" = {
    device = "/dev/disk/by-id/mmc-BJTD4R_0x591758b2-part1";
    fsType = "vfat";
    options = ["umask=0077"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S4EVNMFN522184Y-part2";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
}
