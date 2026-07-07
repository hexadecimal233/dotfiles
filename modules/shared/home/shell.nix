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

        shellInit = ''
          set -g fish_greeting ""
        '';

        shellAliases = {
          cd = "z";
          cat = "bat";
          ls = "eza";
          ll = "eza -l";
          la = "eza -la";
          lt = "eza --tree";
          top = "btop";
          tokscale = "bunx tokscale@latest"; # count tokens
          maleme = "bunx maleme@latest"; # triggered!!
          parrot-live = "curl parrot.live";
          oc = "opencode";
          ff = "fastfetch";
          hy = "hyfetch";
          cz = "chezmoi";
        };
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

      home.packages = with pkgs; [
        tmux
        zellij
        nushell
      ];
    };
  };
}
