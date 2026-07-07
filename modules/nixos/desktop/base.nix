# Desktop infrastructure: dconf, keyring, gvfs, udisks2, fontconfig
# + cross-platform telemetry opt-out
{
  lib,
  config,
  ...
}: let
  cfg = config.hex.nixos.desktop.base;
in {
  options.hex.nixos.desktop.base = {
    enable = lib.mkEnableOption "desktop infrastructure (dconf, keyring, gvfs, fontconfig)" // {default = false;};
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
        hinting.enable = false; # make border smoother
        # subpixel.lcdfilter = "none";
        defaultFonts = {
          monospace = ["Maple Mono NF CN"];
          emoji = ["Noto Color Emoji"];
          sansSerif = ["Source Han Sans SC" "Noto Sans"];
          serif = ["Source Han Serif SC" "Noto Serif"];
        };
      };
    };

    # sessionVariables only works on linux during the whole session
    # variables only take effect in shell sessions.
    environment.variables = {
      # disable telemetry
      OMO_DISABLE_POSTHOG = "1"; # oh-my-openagent
      OMO_SEND_ANONYMOUS_TELEMETRY = "0";
      ASTRO_TELEMETRY_DISABLED = "1"; # astro

      # add stem darkening to remove font weakness
      FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
    };
  };
}
