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
        # make sure everything's right
        hinting.style = "slight";
        subpixel.rgba = "none";

        # subpixel.lcdfilter = "none";
        defaultFonts = {
          monospace = ["Maple Mono NF CN"];
          emoji = ["Noto Color Emoji"];
          sansSerif = ["Source Han Sans SC" "Noto Sans"];
          serif = ["Source Han Serif SC" "Noto Serif"];
        };

        # a note here: NEVER use embolden! fucking hurts my eye and make fonts doubling
        localConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <selectfont>
              <rejectfont>
                <pattern>
                  <patelt name="family">
                    <string>Droid Sans Fallback</string>
                  </patelt>
                </pattern>
                <pattern>
                  <patelt name="family">
                    <string>Droid Sans Japanese</string>
                  </patelt>
                </pattern>
              </rejectfont>
            </selectfont>z
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

      # https://github.com/cloudflare/workers-sdk/issues/8158, fix workerd untrusted certificate
      NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
    };
  };
}
