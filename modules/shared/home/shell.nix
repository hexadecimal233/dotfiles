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

      programs.starship.enable = true;

      # atuin - a bit heavy
      # programs.atuin = {
      #   enable = true;
      #   enableFishIntegration = true;
      # };

      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      programs.direnv = {
        enable = true;
        enableFishIntegration = true;
        nix-direnv.enable = true;
      };

      programs.mise = {
        enable = true;
        # enableFishIntegration defaults to true via home.shell.enableFishIntegration
      };

      home.packages = with pkgs; [
        tmux
        zellij
        nushell
        helix
      ];
    };
  };
}
