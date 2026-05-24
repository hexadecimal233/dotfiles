{pkgs, ...}: {
  security.rtkit.enable = true;

  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      pulse.enable = true;
      # jack.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      # wireplumber.enable = true;
    };
  };

  # ==================== 额外音频工具 ====================
  environment.systemPackages = with pkgs; [
    pavucontrol      # PulseAudio 音量控制 GUI（对 PipeWire 也兼容）
    # helvum           # PipeWire 连线图 GUI
    # easyeffects      # 音频均衡器 / 滤镜（PipeWire 版）
  ];
}
