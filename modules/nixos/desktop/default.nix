{
  lib,
  config,
  ...
}: let
  cfg = config.hex.nixos.desktop;
in {
  imports = [
    ./apps.nix
    ./audio.nix
    ./proxy.nix
    ./wm
    ./home
  ];

  options.hex.nixos.desktop = {
    enable = lib.mkEnableOption "desktop environment and graphics";

    wm = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["hyprland" "niri"]);
      default = null;
      description = "Window manager / compositor: hyprland or niri. Set to null for no WM (bring your own).";
      example = "hyprland";
    };

    # Internal — set by each WM module to declare its UWSM session name
    wmSession = lib.mkOption {
      type = lib.types.str;
      internal = true;
      default = "hyprland.desktop";
      description = "UWSM session desktop file name, set by the selected WM module.";
    };

    audio = {
      enable = lib.mkEnableOption "audio stack";
      usePulse = lib.mkEnableOption "use PulseAudio directly instead of PipeWire";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.sysprof.enable = true;
    services.gvfs.enable = true; # nautilus file manager (trash, mounts)
    services.udisks2.mountOnMedia = false; # manual mount
    fonts = {
      enableDefaultPackages = true;
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = ["Maple Mono NF CN"];
          emoji = ["Noto Color Emoji"];
          sansSerif = ["Noto Sans CJK SC"];
          serif = ["Noto Serif CJK SC"];
        };
      };
    };

    # Sub-options default to parent
    hex.nixos.desktop = {
      wm = lib.mkDefault null;
      audio.enable = lib.mkDefault false;
    };
  };
}
