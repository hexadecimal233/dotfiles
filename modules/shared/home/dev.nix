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

          # stuff
          mise
        ]
        ++ lib.optionals cfg.nodejs.enable [
          # nodejs (global: npx/bunx)
          nodejs_26
          pnpm
          bun
        ];

      home.sessionPath = lib.mkIf cfg.nodejs.enable (lib.mkAfter ["$HOME/.bun/bin"]);
    };
  };
}
