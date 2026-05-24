{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.hexzii.desktop.infra.audio;
  withPulse = cfg.usePulse;
  withPipewire = !withPulse;
in {
  options.hexzii.desktop.infra.audio = {
    usePulse = lib.mkEnableOption "use PulseAudio directly instead of PipeWire";
  };

  config = lib.mkIf config.hexzii.profile.desktopInfra (lib.mkMerge [
    # === Common settings ===
    {
      security.rtkit.enable = true;
    }

    # === PipeWire mode (default) ===
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

      # tools for pipewire mode
      environment.systemPackages = with pkgs; [
        pulseaudio # pulseaudio toolkit (client libs/tools)
        pavucontrol # volume ctrl
        crosspipe # router
        easyeffects # mixer
        openmeters # TODO(update): wait for upstream merge
      ];
    })

    # === PulseAudio mode (for WSL etc.) ===
    (lib.mkIf withPulse {
      # Uses WSLg PulseServer
      /*
      services.pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull;
        support32Bit = true;
      };
      */
      services.pipewire.enable = false;

      #

      environment.systemPackages = with pkgs; [
        pulseaudio
        # pulseaudioFull
        pavucontrol
      ];
    })
  ]);
}
