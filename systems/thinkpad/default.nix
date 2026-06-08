{
  self,
  pkgs,
  lib,
  disko,
  ...
}: {
  imports = [
    self.nixosModules.profile
    disko.nixosModules.disko
    ./disko-config.nix  # 等下创建
  ];

  config = {
    # === 编排选项 ===
    hexzii.profile = {
      desktopInfra = true;
      home = true;
    };
    boot.loader = {
      # 使用 systemd-boot（推荐用于 UEFI 系统）
      systemd-boot.enable = true;
      # 或者使用 GRUB（如果需要双系统，可以改用这个）
      # grub = {
      #   enable = true;
      #   efiSupport = true;
      #   efiInstallAsRemovable = true;
      #   device = "nodev";  # 对于 UEFI，device 设置为 "nodev"
      # };
      efi.canTouchEfiVariables = true;  # 允许 NixOS 修改 EFI 变量
    };

    # === 物理机特有配置 ===
    
    # 使用 PipeWire（物理机推荐，比 PulseAudio 更现代）
    hexzii.desktop.infra.audio.usePulse = false;
    # 启用 NetworkManager（管理 WiFi/网络）
    networking.networkmanager.enable = true;

    # 电源管理（ThinkPad 优化）
    services.tlp.enable = true;
    powerManagement.enable = true;

    # 可选：启用蓝牙
    hardware.bluetooth.enable = true;

    # 可选：启用打印服务
    # services.printing.enable = true;

    # 图形驱动（Intel/AMD/NVIDIA 根据实际情况选择）
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    
    # 如果是 Intel 核显（ThinkPad 常见）
    # hardware.opengl.extraPackages = with pkgs; [ intel-media-driver vaapiIntel ];
  };
}
