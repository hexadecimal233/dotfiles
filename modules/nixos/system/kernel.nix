{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    # TODO: add enable options?
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 10; # reduce swap usage
    };
  };
}
# TODO: add configurable kernels (cachy, vanilla, etc.)

