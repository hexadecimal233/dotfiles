# Input method: fcitx5 + Rime (rime-ice / 雾凇拼音) + Mozc (Japanese) + Vinput (Voice)
#
# Rime config overrides live in ~/.local/share/fcitx5/rime/ (chezmoi-managed):
#   - default.custom.yaml   — page size, key bindings, Shift → English layout
#   - rime_ice.custom.yaml  — external grammar model config
#
# Usage:
#   - Switch input methods: Super + Space
#   - Switch Rime schemas: Ctrl + ` (backtick)
#   - Shift key: does nothing (use Super+Space to switch)
#   - Voice input: Right Alt (hold to record, release to commit)
{
  lib,
  config,
  pkgs,
  fcitx5-vinput,
  ...
}: {
  options.hex.nixos.system.ime.enable =
    lib.mkEnableOption "fcitx5 input method (Rime 雾凇拼音 + Mozc Japanese)"
    // {default = false;};

  config = lib.mkIf config.hex.nixos.system.ime.enable {
    # ── Fcitx5 framework ────────────────────────────────────────────

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        # Enable Wayland frontend — suppresses GTK/QT warnings on Hyprland
        waylandFrontend = true;

        # NOTE: Do NOT set ignoreUserConfig = true. It sets SKIP_FCITX_USER_PATH=1
        # which makes StandardPaths::userDirectory(PkgData) return an empty path,
        # breaking Rime's user data dir resolution (mkdir("rime") at CWD "/" → EACCES).
        # Instead, delete conflicting local config files (~/.config/fcitx5/config,
        # ~/.config/fcitx5/profile) and let the system config take precedence.

        # Addon engines
        # Note: fcitx5-gtk, fcitx5-qt, and fcitx5-configtool are already
        # auto-included by qt6Packages.fcitx5-with-addons. Only list
        # extra addon engines here. Do NOT add fcitx5 or its addons to
        # environment.systemPackages — the wrapper handles addon detection.
        addons = with pkgs; [
          # Chinese: rime-ice (雾凇拼音)
          (fcitx5-rime.override {
            rimeDataPkgs = [pkgs.rime-ice];
          })

          # Japanese: Mozc UT variant (extended dictionaries)
          fcitx5-mozc-ut

          # TODO: re-enable after find a way to cache
          # fcitx5-vinput.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];

        # we do not add options (/etc/xdg/fcitx5/config)
      };
    };

    # Environment variables (GTK_IM_MODULE, QT_IM_MODULE, XMODIFIERS)
    # are handled automatically by the NixOS fcitx5 module.

    # ── Vinput daemon ────────────────────────────────────────────────
    # https://github.com/xifan2333/fcitx5-vinput/blob/main/packaging/vinput-daemon.service
    /*

    systemd.user.services.vinput-daemon = {
      description = "Vinput Voice Input Daemon";
      after = ["pipewire.service"];
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.fcitx.Vinput";
        ExecStart = "${fcitx5-vinput.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/vinput-daemon";
      };
    };
    */
  };
}
