# 网络工具
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ethtool
    iperf3
  ];
}
