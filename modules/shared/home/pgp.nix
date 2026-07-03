{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.home.pgp;
in {
  options.hex.shared.home.pgp.enable = lib.mkEnableOption "openpgp stuff";

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentry.package =
          if pkgs.stdenv.hostPlatform.isDarwin
          then pkgs.pinentry_mac
          else pkgs.pinentry-curses;
      };

      home.packages = with pkgs; [
        gnupg
        gpg-tui
        sequoia-sq
      ];
    };
  };
}
