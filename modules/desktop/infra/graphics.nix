{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vulkan-loader # vulkan support
  ];
}
