# tools & stuff used in terminal environment
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # files
    wget
    curl
    zip
    unzip

    # monitoring
    powertop
    htop
    atop
    btop
    iotop
    lsof

    # hardware
    lshw
    pciutils
    usbutils
    dmidecode
    lm_sensors
    # efibootmgr

    # network
    rustnet
    vnstat
    wavemon
    ethtool
    iperf3
    dnsutils
    net-tools
    rsync # added but currently unused

    # graphics
    vulkan-tools
    clinfo
    mesa-demos
  ];
}
