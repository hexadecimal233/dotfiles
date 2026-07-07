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
          else pkgs.pinentry-gnome3; # or pinentry-qt
        # TODO: add an option to use curses on demand (e.g. ssh)
      };

      home.packages = with pkgs; [
        # gnupg, consider moving to sequoia
        gpg-tui
        sequoia-chameleon-gnupg # will override gpg commma
        sequoia-sq # still does not support pq :(
      ];
    };
  };
}
