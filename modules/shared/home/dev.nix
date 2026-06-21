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

          # build tools
          gcc
          pkg-config

          # justfile
          just-lsp

          # lua
          lua-language-server
          # emmylua-ls

          # stuff
          mise
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
        ];

      home.sessionPath = [
        "$HOME/.bun/bin"
        "$HOME/.local/share/pnpm/bin"

        # below unrecommended, but added just in case
        "$HOME/.cargo/bin"
        "$HOME/go/bin"
      ];
    };
  };
}
