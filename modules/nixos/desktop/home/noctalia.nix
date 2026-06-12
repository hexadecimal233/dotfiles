# Noctalia v5 desktop shell
# Requires: noctalia flake input (github:noctalia-dev/noctalia)
{
  lib,
  config,
  pkgs,
  noctalia,
  ...
}: let
  cfg = config.hex.nixos.home.desktop.noctalia;
in {
  options.hex.nixos.home.desktop.noctalia = {
    enable = lib.mkEnableOption "Noctalia v5 Wayland desktop shell" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      imports = [noctalia.homeModules.default];
      programs.noctalia.enable = true;

      # UWSM session env vars
      xdg.configFile."uwsm/env".text = ''
        XCURSOR_SIZE=24
      '';
    };
  };
}
