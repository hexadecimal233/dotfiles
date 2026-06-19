{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.desktop.audio;
  withPulse = cfg.usePulse;
  withPipewire = !withPulse;
in {
  config = lib.mkIf (config.hex.nixos.desktop.enable && cfg.enable) (lib.mkMerge [
    {
      security.rtkit.enable = true;
    }

    # pipewire mode (for better wiring support)
    (lib.mkIf withPipewire {
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        pulse.enable = true;
        jack.enable = true;
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
        openmeters
        playerctl
      ];
    })

    # pulseaudio mode
    (lib.mkIf withPulse {
      services.pipewire.enable = false;
      environment.systemPackages = with pkgs; [
        pulseaudio
        pavucontrol
      ];
    })
  ]);
}
