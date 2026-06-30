# WM dispatcher — always imported, enables greetd/UWSM/env for any WM
{
  config,
  lib,
  pkgs,
  ...
}: let
  uwsm = lib.getExe config.programs.uwsm.package;
in {
  imports = [
    ./hyprland.nix
    ./niri.nix
  ];

  options.hex.nixos.desktop = {
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
  };

  config = lib.mkIf (config.hex.nixos.desktop.wm != null) {
    # UWSM — systemd session manager, required by all WMs
    programs.uwsm.enable = true;

    # greetd — tuigreet login, then UWSM → selected WM
    #
    # ─── gnome-keyring cannot auto-unlock with fingerprint ─────────────
    #
    # NOT a greetd bug. Linux has no auth→keyring glue layer:
    #
    #   • PAM's single authtok channel carries yes/no from pam_fprintd,
    #     not a password → pam_gnome_keyring gets NULL → keyring stays locked.
    #   • gnome-keyring uses the login password as the AES key directly
    #     (no KDF/TPM/escrow layer — change passwd and your keyring dies).
    #   • Windows/macOS/Android all decouple auth from key material via
    #     TPM/Secure Enclave/TEE. Linux has TPM 2.0 but fprintd, gnome-keyring,
    #     systemd, and tpm2-tss are four independent projects with zero
    #     integration. Nobody owns the auth→keyring pipeline.
    #
    # Community reception (10 years, same wall):
    #   - "defeats the point of biometric login" — Fedora Discussion 2025
    #   - "your fingerprint is not your password" — Arch BBS 2024
    #   - "no interface to store those secrets securely" — mjg59 2023
    #   - closed as WONTFIX — AOSC Issue #425 2016
    #
    # References:
    #   https://mjg59.dreamwidth.org/68537.html
    #   https://bbs.archlinux.org/viewtopic.php?id=310290
    #   https://discussion.fedoraproject.org/t/164734
    #   https://github.com/AOSC-Dev/aosc-os-abbs/issues/425
    #   https://github.com/Tunahanyrd/tpm-keyring-unlock
    #   https://github.com/jmylchreest/rosec
    #
    # ────────────────────────────────────────────────────────────────────
    services.greetd = {
      enable = true;
      restart = false;
      settings = {
        terminal.vt = 1;
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd '${uwsm} start ${config.hex.nixos.desktop.wmSession}'";
          user = "greeter";
        };
      };
    };

    # xdg portals — shared base, WM-specific backends in each WM file
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "*";
    };

    # UWSM session env — shared across WMs, kept inline (not managed by chezmoi)
    home-manager.users.hexzii.xdg.configFile."uwsm/env".text = ''
      TERMINAL=ghostty
    '';

    # Session env — hint Electron apps to use Wayland, default tools
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      TERMINAL = "ghostty";
      EDITOR = "hx";
      VISUAL = "zeditor";
      # xdg-open: force portal path (async)
      NIXOS_XDG_OPEN_USE_PORTAL = "1";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
