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
        defaultFonts = {
          monospace = ["Maple Mono NF CN"];
          emoji = ["Noto Color Emoji"];
          sansSerif = ["Noto Sans CJK SC"];
          serif = ["Noto Serif CJK SC"];
        };
        localConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <!-- Lightly bump weight for fonts between Regular (80) and Medium (100) -->
            <match target="font">
              <test name="weight" compare="more_eq">
                <int>80</int>
              </test>
              <test name="weight" compare="less_eq">
                <int>100</int>
              </test>
              <edit name="weight" mode="assign">
                <plus>
                  <name>weight</name>
                  <int>20</int>
                </plus>
              </edit>
            </match>
          </fontconfig>
        '';
      };
    };


    # sessionVariables only works on linux during the whole session
    # variables only take effect in shell sessions.
    environment.variables = {
      # disable telemetry
      OMO_DISABLE_POSTHOG = "1"; # oh-my-openagent
      OMO_SEND_ANONYMOUS_TELEMETRY = "0";
      ASTRO_TELEMETRY_DISABLED = "1"; # astro
    };
  };
}
