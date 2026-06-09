{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hex.shared.home.dev;
in {
  options.hex.shared.home.dev.enable = lib.mkEnableOption "dev environment (compilers, LSPs)";

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs; [
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

        # nodejs (global: npx/bunx)
        nodejs_26
        pnpm
        bun
      ];

      home.sessionPath = lib.mkAfter ["$HOME/.bun/bin"];
    };
  };
}
