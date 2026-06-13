# Input method: fcitx5 + Rime (Chinese) + Mozc (Japanese)
#
# Rime schema options:
#   - "wanxiang" (万象拼音): Feature-rich, LSTM grammar model.
#     ⚠️ After first deploy, run to download the grammar model:
#        rime-wanxiang-grammar
#        Then: fcitx5-configtool → Addons → Rime → Deploy
#   - "ice" (雾凇拼音): Lightweight, works out of the box.
#
# Usage:
#   - Switch input methods: Alt + Space
#   - Switch Rime schemas: Ctrl + ` (backtick)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.system.ime;
  rimeSchemaPkg =
    if cfg.rimeSchema == "wanxiang"
    then pkgs.rime-wanxiang
    else pkgs.rime-ice;
in {
  options.hex.nixos.system.ime = {
    enable =
      lib.mkEnableOption "fcitx5 input method (Rime Chinese + Mozc Japanese)"
      // {default = false;};

    rimeSchema = lib.mkOption {
      type = lib.types.enum ["wanxiang" "ice"];
      default = "wanxiang";
      description = ''
        Rime schema.
        "wanxiang" = 万象拼音 (richer, needs grammar model download)
        "ice"      = 雾凇拼音 (lighter, works immediately)
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # ── Fcitx5 framework ────────────────────────────────────────────

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        # Enable Wayland frontend — suppresses GTK/QT warnings on Hyprland
        waylandFrontend = true;

        # Addon engines
        # Note: fcitx5-gtk, fcitx5-qt, and fcitx5-configtool are already
        # auto-included by qt6Packages.fcitx5-with-addons. Only list
        # extra addon engines here. Do NOT add fcitx5 or its addons to
        # environment.systemPackages — the wrapper handles addon detection.
        addons = with pkgs; [
          # Chinese: Rime with the selected schema
          (fcitx5-rime.override {
            rimeDataPkgs = [rimeSchemaPkg];
          })

          # Japanese: Mozc UT variant (extended dictionaries)
          fcitx5-mozc-ut
        ];

        # Declarative input method group config
        settings = {
          inputMethod = {
            GroupOrder."0" = "Default";

            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              # Default to Rime (Chinese) on activation
              DefaultIM = "rime";
            };

            # Group items: keyboard-us → rime (Chinese) → mozc (Japanese)
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "rime";
            "Groups/0/Items/2".Name = "mozc";
          };
        };
      };
    };

    # Environment variables (GTK_IM_MODULE, QT_IM_MODULE, XMODIFIERS)
    # are handled automatically by the NixOS fcitx5 module.

    # ── rime-wanxiang grammar model helper ──────────────────────────
    # Only installed when rimeSchema = "wanxiang". Run once after deploy.

    environment.systemPackages = lib.optionals (cfg.rimeSchema == "wanxiang") [
      (pkgs.writeShellScriptBin "rime-wanxiang-grammar" ''
        set -euo pipefail

        GRAM_FILE="wanxiang-lts-zh-hans.gram"
        GRAM_URL="https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/''${GRAM_FILE}"
        RIME_DIR="$HOME/.local/share/fcitx5/rime"
        DEST="''${RIME_DIR}/''${GRAM_FILE}"

        if [ -f "$DEST" ]; then
          echo "✅ Grammar model already exists at $DEST"
          echo "   To re-download: rm $DEST && rime-wanxiang-grammar"
          exit 0
        fi

        echo "📥 Downloading wanxiang grammar model..."
        mkdir -p "$RIME_DIR"
        ${pkgs.wget}/bin/wget -q --show-progress -O "$DEST" "$GRAM_URL"

        echo ""
        echo "✅ Grammar model installed to $DEST"
        echo "   Next step: deploy Rime to apply"
        echo "   fcitx5-configtool → Addons → Rime → Deploy"
      '')
    ];
  };
}
