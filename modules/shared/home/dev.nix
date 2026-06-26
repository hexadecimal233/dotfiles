{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hex.shared.home.dev;
in {
  options.hex.shared.home.dev = {
    enable = lib.mkEnableOption "dev environment (compilers, LSPs)";
    nodejs = {
      enable = lib.mkEnableOption "Node.js ecosystem (nodejs, pnpm, bun)" // {default = false;};
    };
    ai = {
      enable = lib.mkEnableOption "AI / Vibe coding / AIGC stuff" // {default = false;};
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs;
        [
          # nix
          alejandra
          nixd

          # justfile
          just-lsp

          # lua
          lua-language-server
          # emmylua-ls

          # stuff
          uv
          betterleaks
        ]
        ++ lib.optionals cfg.nodejs.enable [
          # nodejs (global: npx/bunx)
          nodejs_26
          pnpm
          bun
        ]
        ++ lib.optionals cfg.ai.enable [
          opencode
          rtk
        ];

      home.sessionPath = [
        "$HOME/.bun/bin"
        "$HOME/.local/share/pnpm/bin"

        # below unrecommended, but added just in case
        "$HOME/.cargo/bin"
        "$HOME/go/bin"
      ];

      programs.mise = {
        enable = true;
        # enableFishIntegration defaults to true via home.shell.enableFishIntegration
      };
    };
  };
}
