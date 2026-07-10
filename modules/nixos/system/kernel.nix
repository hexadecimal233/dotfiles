{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.kernel;
in {
  options.hex.nixos.system.kernel = {
    variant = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["vanilla" "cachyos"]);
      default = "vanilla";
    };
  };

  config = lib.mkIf (cfg.variant != null) (lib.mkMerge [
    (lib.mkIf (cfg.variant == "vanilla") {
      boot.kernelPackages = pkgs.linuxPackages_latest;

      boot.kernel.sysctl = {
        "vm.swappiness" = lib.mkDefault 10; # in-memory first, then disk
      };
    })

    # CachyOS 内核配置
    (lib.mkIf (cfg.variant == "cachyos") {
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

      boot.kernel.sysctl = {
        "vm.swappiness" = lib.mkDefault 150; # make system utilize zram more aggresively
      };

      zramSwap.enable = true;
    })
  ]);
}
