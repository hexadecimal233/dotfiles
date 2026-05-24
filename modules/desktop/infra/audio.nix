{pkgs, ...}: {
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;

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

      wireplumber.enable = true;
    };
  };

  # tools
  environment.systemPackages = with pkgs; [
    pulseaudio # pulseaudio toolkit
    pavucontrol # volume ctrl
    crosspipe # router
    easyeffects # mixer
    openmeters # TODO(update): wait for upstream merge
  ];
}
