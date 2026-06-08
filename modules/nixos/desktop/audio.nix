{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.desktop.audio;
  withPulse = cfg.usePulse;
  withPipewire = !withPulse;
in {
  config = lib.mkIf (config.hex.desktop.enable && cfg.enable) (lib.mkMerge [
    {
      security.rtkit.enable = true;
    }

    (lib.mkIf withPipewire {
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        pulse.enable = true;
        # jack.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        wireplumber.enable = true;
      };
      environment.systemPackages = with pkgs; [
        pulseaudio # pulseaudio toolkit (client libs/tools)
        pavucontrol # volume ctrl
        crosspipe # router
        easyeffects # mixer
        openmeters # TODO(update): wait for upstream merge
      ];
    })

    (lib.mkIf withPulse {
      services.pipewire.enable = false;
      environment.systemPackages = with pkgs; [
        pulseaudio
        pavucontrol
      ];
    })
  ]);
}
