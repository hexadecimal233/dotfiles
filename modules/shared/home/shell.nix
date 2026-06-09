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
          # ---- Proxy ----
          # FIXME: hardcoded proxy IP, move to sessionVariables later
          set -g _PROXY_DEFAULT "http://192.168.2.149:10808"
          set -g _PROXY_FILE "$HOME/.cache/proxy-state"

          if test -f "$_PROXY_FILE"
            source "$_PROXY_FILE"
          end

          function proxy_on -d "Enable proxy"
            set proxy (test -n "$argv[1]"; and echo "$argv[1]"; or echo "$_PROXY_DEFAULT")
            mkdir -p (dirname "$_PROXY_FILE")
            echo "set -gx http_proxy $proxy
            set -gx https_proxy $proxy
            set -gx HTTP_PROXY $proxy
            set -gx HTTPS_PROXY $proxy" > "$_PROXY_FILE"
            source "$_PROXY_FILE"
            echo "proxy ON  -> $proxy"
          end

          function proxy_off -d "Disable proxy"
            set -e http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
            rm -f "$_PROXY_FILE"
            echo "proxy OFF"
          end
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
          maleme = "bunx maleme@latest"; # fxxk
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
