{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.home.shell;
in {
  options.hex.shared.home.shell.enable = lib.mkEnableOption "shell environment (fish, starship, zoxide, direnv)";

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      programs.fish = {
        enable = true;
      };

      home.packages = with pkgs; [
        fish
        starship
        zoxide
        direnv
        nix-direnv # will do this later
        mise
        tmux
        zellij
        nushell
        helix
      ];
    };
  };
}
