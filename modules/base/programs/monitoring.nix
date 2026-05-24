# 系统监控工具
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    powertop
    htop
    btop
    iotop
    lsof
    lshw
    pciutils
    usbutils
    clinfo
    mesa-demos
    vulkan-tools
    dmidecode
    lm_sensors
  ];
}
