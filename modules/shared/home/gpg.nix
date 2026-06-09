{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.home.gpg;
in {
  options.hex.shared.home.gpg.enable = lib.mkEnableOption "gpg-agent with SSH support";

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentry.package = pkgs.pinentry-curses;
      };
    };
  };
}
