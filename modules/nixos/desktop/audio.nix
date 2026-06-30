# Audio: PipeWire or PulseAudio, selected via audio.usePulse
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
  options.hex.nixos.desktop.audio = {
    enable = lib.mkEnableOption "audio stack" // {default = false;};
    usePulse = lib.mkEnableOption "use PulseAudio directly instead of PipeWire" // {default = false;};
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
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

        # cli
        playerctl
        alsa-utils
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
