{
  lib,
  config,
  ...
}: let
  cfg = config.hex.nixos.desktop;
in {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./proxy.nix
    ./wm.nix
    ./home
  ];

  options.hex.nixos.desktop = {
    enable = lib.mkEnableOption "desktop environment and graphics";
    hyprland.enable = lib.mkEnableOption "Hyprland compositor";
    audio = {
      enable = lib.mkEnableOption "audio stack";
      usePulse = lib.mkEnableOption "use PulseAudio directly instead of PipeWire";
    };
    fonts.enable = lib.mkEnableOption "fonts";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    # Sub-options default to parent
    hex.nixos.desktop = {
      hyprland.enable = lib.mkDefault false;
      audio.enable = lib.mkDefault false;
      fonts.enable = lib.mkDefault false;
    };
  };
}
