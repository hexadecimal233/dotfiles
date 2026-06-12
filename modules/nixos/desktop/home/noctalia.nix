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

      # Tell Hyprland to start Noctalia via Lua event (systemd disabled — UWSM)
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        settings = {
          on = {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''
                function() hl.exec_cmd("qs -c noctalia-shell") end
              '')
            ];
          };
        };
      };

      # UWSM session env vars
      xdg.configFile."uwsm/env".text = ''
        XCURSOR_SIZE=24
      '';
    };
  };
}
