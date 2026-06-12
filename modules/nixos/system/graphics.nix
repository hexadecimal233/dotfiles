# Graphics tools (Vulkan, OpenCL, Mesa)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.graphics;
in {
  options.hex.nixos.system.graphics = {
    enable = lib.mkEnableOption "graphics tools (vulkan-tools, clinfo, mesa-demos)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.systemPackages = with pkgs; [
      vulkan-tools # vulkaninfo
      vulkan-loader
      clinfo # OpenCL info
      mesa-demos # glxinfo, eglinfo
    ];
  };
}
