{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.kernel;
in {
  options.hex.nixos.system.kernel = {
    enable = lib.mkEnableOption "kernel tuning (linuxPackages_latest, swappiness)" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 10; # reduce swap usage
    };
  };
}
# TODO: add configurable kernels (cachy, vanilla, etc.)

